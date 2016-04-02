#!/usr/bin/perl -w

#
# Copyright (C) 2013--2016 Alex J. Grede
# GPL v3, See LICENSE.txt for details
# This function is part of SAMIS (https://github.com/agrede/SAMIS)

use warnings;
use strict;
use Spreadsheet::ParseExcel;
use JSON;
use POSIX;

# Open File --------------------------------------------------------------------
my $f = $ARGV[0];
my $parser = Spreadsheet::ParseExcel->new();
my $workbook = $parser->parse($f);

# Read Settings ----------------------------------------------------------------
# Initialize settings to be read and set default values for old versions
my $rtn = {};
$rtn->{"DCISO"} = 0;
$rtn->{"HighPower"} = 1;
$rtn->{"ALC"} = 0;
$rtn->{"MeasurementsPerStep"} = 1;
$rtn->{"SignalLevel"} = 0.05;
$rtn->{"VFirst"} = 1;
$rtn->{"Model"} = 1;
$rtn->{"IntegrationTime"} = 0;
$rtn->{"Fsteps"} = 1;
$rtn->{"SourceMonitor"} = 0;
$rtn->{"StartV"} = 0;
$rtn->{"StopV"} = 0;
$rtn->{"StepV"} = 1;

if (!defined $workbook) {die $parser->error() . "\n"};
my $settings = $workbook->worksheet("Settings");
if (!defined $settings) {die $parser->error() . "\n"};
my ($row_min, $row_max) = $settings->row_range();

# Read and set values
for my $row ($row_min .. $row_max) {
    next unless $settings->get_cell($row,3);

    my $key = $settings->get_cell($row,0)->unformatted();
    my $value = $settings->get_cell($row,3)->unformatted();

    if (defined $rtn->{$key}) {
        $rtn->{$key} = $value +=0; # Set and force to be double
    }
}

# Calculate the number of voltage steps from settings
$rtn->{"Vsteps"} = floor(abs($rtn->{"StartV"}-$rtn->{"StopV"})/$rtn->{"StepV"})+1;


# Find Index locations ---------------------------------------------------------
# Initialize columns to find and set default values
my $ind = {};
$ind->{"V"} = 1;
$ind->{"C"} = 2;
$ind->{"G_or_R"} = 3;
$ind->{"F"} = 4;
$ind->{"VAC"} = 5;
$ind->{"IAC"} = 6;

my $data = $workbook->worksheet("Data");
if (!defined $data) {die $parser->error() . "\n"};
($row_min, $row_max) = $data->row_range();
my ($col_min, $col_max) = $data->col_range();

# Search first row for columns
for my $col ($col_min .. $col_max) {
    next unless $data->get_cell($row_min,$col);
    my $header = $data->get_cell($row_min,$col)->unformatted();

    if (defined $ind->{$header}) {
        $ind->{$header} = $col;
    }
}

# Read measured data -----------------------------------------------------------
# Initialize data arrays (3D matrix adds the complexity)
my @colData = ("V","A","B","f","VAC","IAC");
for my $col (@colData) {
    $rtn->{$col} = {};
    $rtn->{$col}->{"_ArrayType_"} = "double";
    @{$rtn->{$col}->{"_ArraySize_"}} = ($rtn->{"Vsteps"},
                                        $rtn->{"Fsteps"},
                                        $rtn->{"MeasurementsPerStep"});
    $rtn->{$col}->{"_ArrayData_"} = ();
}

# Define index values
# Multiple measurments at same V and f will be grouped
# Loop can than be with changing frequency or chaning V
# This is set in the "VFirst" Setting (making it for (f) {for (V) {}} if true)
my $mindx = 0; # Current measurment index (for multiple measurments)
my $findx = 0; # Current frequency index
my $vindx = 0; # Current voltage index

# Read data
for my $row (($row_min+1) .. $row_max) {
    # Skip any row without data
    next unless $data->get_cell($row, $ind->{"C"});
    next unless $data->get_cell($row, $ind->{"C"})->unformatted() ne "";

    # Check to see if number of measurments indicates a change in parameters
    if ($mindx == $rtn->{"MeasurementsPerStep"}) {
        $mindx = 0; # Reset measurments counter

        # Check for stepping order
        if ($rtn->{"VFirst"}) {         # Indicates for (f) { for (V) {} }
            if (($vindx+1) < $rtn->{"Vsteps"}) { # Increment Voltage counter
                $vindx++;
            } else {                    # Reset V conter, Increment f counter
                $vindx = 0;
                $findx++;
            }
        } else {                        # Indciates for (V) { for (f) {}}
            if (($findx+1) < $rtn->{"Fsteps"}) { # Increment frequency counter
                $findx++;
            } else {                    # Reset f counter, Increment V counter
                $findx = 0;
                $vindx++;
            }
        }
    }

    # Read values from worksheet
    my $V   = $data->get_cell($row,$ind->{"V"})->unformatted();
    my $A   = $data->get_cell($row,$ind->{"G_or_R"})->unformatted();
    my $B   = $data->get_cell($row,$ind->{"C"})->unformatted();
    my $f   = $data->get_cell($row,$ind->{"F"})->unformatted();
    my $VAC = 0;
    my $IAC = 0;
    # Check to see if VAC and IAC columns exist for backwards compatablity
    if ($ind->{"IAC"}<=$col_max) {
       $VAC = $data->get_cell($row,$ind->{"VAC"})->unformatted();
       $IAC = $data->get_cell($row,$ind->{"IAC"})->unformatted();
    }

    # Appends data to arrays, Will set measured values to _NaN_ if unbalanced
    $rtn->{"V"}->{"_ArrayData_"}[$findx][$vindx][$mindx] = $V+0;
    $rtn->{"A"}->{"_ArrayData_"}[$findx][$vindx][$mindx] = (abs($A) < 1e35) ? $A+0 : "_NaN_";
    $rtn->{"B"}->{"_ArrayData_"}[$findx][$vindx][$mindx] = (abs($B) < 1e35) ? $B+0 : "_NaN_";
    $rtn->{"f"}->{"_ArrayData_"}[$findx][$vindx][$mindx] = $f+0;
    $rtn->{"VAC"}->{"_ArrayData_"}[$findx][$vindx][$mindx] = $VAC+0;
    $rtn->{"IAC"}->{"_ArrayData_"}[$findx][$vindx][$mindx] = $IAC+0;
    $mindx++;
}

print encode_json($rtn);
