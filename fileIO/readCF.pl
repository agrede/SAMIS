#!/usr/bin/perl -w
#
# Copyright (C) 2013 Alex J. Grede
# GPL v3, See LICENSE.txt for details
# This function is part of SAMIS (https://github.com/agrede/SAMIS)

use warnings;
use strict;
use Spreadsheet::ParseExcel;
use JSON;

# Open File --------------------------------------------------------------------
my $f = $ARGV[0];
my $parser = Spreadsheet::ParseExcel->new();
my $workbook = $parser->parse($f);

# Read Settings ----------------------------------------------------------------
my $rtn = {};
# Initialize fields to be gathered and set defaults for older versions
$rtn->{"V"} = 0;
$rtn->{"DCISO"} = 0;
$rtn->{"HighPower"} = 1;
$rtn->{"ALC"} = 0;
$rtn->{"MeasurementsPerStep"} = 1;
$rtn->{"SignalLevel"} = 0.05;
$rtn->{"Model"} = 1;
$rtn->{"IntegrationTime"} = 2;
$rtn->{"Fsteps"} = 28;

if (!defined $workbook) {die $parser->error() . "\n"};
my $settings = $workbook->worksheet("Settings");
if (!defined $settings) {die $parser->error() . "\n"};

my ($row_min, $row_max) = $settings->row_range();

for my $row ($row_min .. $row_max) {
    # Skip over unused lines
    next unless $settings->get_cell($row,3);
    next unless $settings->get_cell($row,3)->unformatted() ne "";
    
    my $key = $settings->get_cell($row,0)->unformatted();
    my $value = $settings->get_cell($row,3)->unformatted();

    # Only include predefined fields
    if (defined $rtn->{$key}) {
        $rtn->{$key} = $value;
    }
}

# Force values to be treated as numbers
$rtn->{"V"} += 0;
$rtn->{"DCISO"} += 0;
$rtn->{"HighPower"} += 0;
$rtn->{"ALC"} += 0;
$rtn->{"MeasurementsPerStep"} += 0;
$rtn->{"SignalLevel"} += 0;
$rtn->{"Model"} += 0;
$rtn->{"IntegrationTime"} += 0;
$rtn->{"Fsteps"} += 0;


# Find column locations --------------------------------------------------------
# Initialize hash of column locations
my $ind = {};
$ind->{"C"} = 1;
$ind->{"G_or_R"} = 2;
$ind->{"F"} = 3;

my $data = $workbook->worksheet("Data");
if (!defined $data) {die $parser->error() . "\n"};
($row_min, $row_max) = $data->row_range();
my ($col_min, $col_max) = $data->col_range();

for my $col ($col_min .. $col_max) {
    next unless $data->get_cell($row_min,$col);
    my $header = $data->get_cell($row_min,$col)->unformatted();

    if (defined $ind->{$header}) {
        $ind->{$header} = $col;
    }
}

# Read measurments -------------------------------------------------------------
# Initialize columns
$rtn->{"f"} = ();
$rtn->{"A"} = (); # Used to prevent conflicts and more generic for futre
$rtn->{"B"} = ();

my $mindx = 0;
my $findx = 0;
for my $row (($row_min+1) .. $row_max) {
    next unless $data->get_cell($row, $ind->{"C"});
    next unless $data->get_cell($row,$ind->{"C"})->unformatted() ne "";
    if ($mindx == $rtn->{"MeasurementsPerStep"}) {
        $mindx = 0;
        $findx++;
    }
    my $A = $data->get_cell($row,$ind->{"G_or_R"})->unformatted();
    my $B = $data->get_cell($row,$ind->{"C"})->unformatted();
    my $f = $data->get_cell($row,$ind->{"F"})->unformatted();
    # Set values and replace with _NaN_ if values are large (unbalanced)
    $rtn->{"A"}[$mindx][$findx] = (abs($A) < 1e35) ? $A+0 : "_NaN_";
    $rtn->{"B"}[$mindx][$findx] = (abs($B) < 1e35) ? $B+0 : "_NaN_";
    $rtn->{"f"}[$mindx][$findx] = $f+0;
    $mindx++;
}

# Return JSON formatted data stream --------------------------------------------
print encode_json($rtn);
