SAMIS
=====

Simulation and Admittance Analysis for Advanced Metal-Insulator-Semiconductor Characterization

Collection of Octave/MATLAB functions for use in simulation and characterization of metal-insulator-semiconductor capacitors. Simulation component is available to run at [nanoHub.org](https://nanohub.org/tools/samis/).

For more information on the theory behind the calculations see:
A.J. Grede and S.L. Rommel, ["Components of channel capacitance in metal-insulator-semiconductor capacitors."](http://dx.doi.org/10.1063/1.4821835) Journal of Applied Physics, vol.  114, no. 11, p. 114510, 2013.

Dependencies
------------

* `fermi_dirac_half.m`
    + GNU Octave: [GNU Scientific Library Package](http://octave.sourceforge.net/gsl/)
    + MATLAB: A basic method is included if `generalFunctions/fermi_dirac_half_MATLAB.m` is renamed to `fermi_dirac_half.m`
* [JSONLAB](http://iso2mesh.sourceforge.net/cgi-bin/index.cgi?jsonlab) (v1.0 beta Included in `fileIO/jsonlab/`)
* Only for reading XLS files for analysis of measured data:
    + [Perl 5](http://perl.org)
    + Perl package: [JSON](http://search.cpan.org/dist/JSON/) >=v2.59
    + Perl package: [Spreadsheet::ParseExcel](http://search.cpan.org/dist/Spreadsheet-ParseExcel/) >=v0.59
* [Rappture](http://www.rapture.org) Needed for GUI

Important Functions
-------------------
* `analysis_load_paths.m` loads all needed paths for accessing functions
* `ditAllMethods.m` steps through the general process of simulating and analyzing measurements
* Simulation:
    + `simulation/simMOSCAP.m` is the main function for simulating
    + `simulation/sepCap.m` is the main function for separating capacitance components
    + `simulation/citQit.m` calculates interface state capacitance and charge for arbitrary interface state distributions
* Interface state Extraction:
    + Castagné and Vapaille method (High-Low CV) -- `analysis/castagneVapaille.m`
    + Terman Method (Method used depends on how simulation is performed) -- `analysis/termanMethod.m`
    + Nicollian and Goetzberger (Conductance method) -- `analysis/nicollianGoetzberger.m`
* Important files:
    + `constants/master.json` contains physical constants for use with GaInAs
    + `materialStacks/Sample.json` contains a InGaAs with 1e17 cm-3 Si doping and a 10nm Al2O3 as an example

Material Constants
------------------

Although GaAs, InAs, GaInAs, Al2O3, SiO2 material constants are provided. Other materials can be added making a new master.json constants file.

* `format.json` is the format for specifying constants
* Constants used to compile `constants/master.json`:
    + `constants/Vurgaftman.json` contains band parameters [1] [2]
    + `constants/NSM.json` contains semiconductor dielectric constants, hole DOS effective masses, and a number of impurity ionization energies. [3]
    + `constants/OMadelung.json` contains additional semiconductor dielectric constants and impurity ionization energies. [4]
    + `constants/Robertson.json` contains dielectric constants [5]
* `constants/makeMaster.m` outputs a structure variable with constants in correct format from a cell array of paths
    + Multiple sources can be merged
    + Source preference is determined by order in cell array (any constants in source2 that have already been defined by source1 will be ignored)
* `fileIO/jsonlab/savejson.m` is used to save the structure into a JSON file

1. I. Vurgaftman, J. R. Meyer, and L. R. Ram-Mohan, [“Band parameters for III-V compound semiconductors and their alloys,”](http://dx.doi.org/10.1063/1.1368156) Journal of Applied Physics, vol. 89, no. 11, p. 5815, 2001.
2. I. Vurgaftman and J.R. Meyer, ["Band parameters for nitrogen-containing semiconductors."](http://dx.doi.org/10.1063/1.1600519) Journal of Applied Physics, vol. 94, no. 6, p. 3675, 2003.
3. NSM Archive, http://www.ioffe.rssi.ru/SVA/NSM/Semicond/
4. O. Madelung, Semiconductors: Data Handbook, Springer, 2004, ISBN: 9783540404880.
5. J. Robertson, [“High dielectric constant gate oxides for metal oxide Si transistors,”](http://dx.doi.org/10.1088/0034-4885/69/2/R02) Reports on Progress in Physics, vol. 69, no. 2, pp. 327–396, Feb. 2006.
