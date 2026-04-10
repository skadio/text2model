% Parameters
int: probes_per_salinity = 3;
int: probes_per_ph = 2;

int: min_ph_tests = 250;
int: min_total_tests = 400;
float: max_ph_to_salinity_ratio = 1.5;

% Variables
var 0..1000000: salinity_tests;
var 0..1000000: ph_tests;
var 0..1000000000: total_probes;

% Constraints
constraint ph_tests >= min_ph_tests;
constraint salinity_tests + ph_tests >= min_total_tests;

% ph_tests <= 1.5 * salinity_tests  <=>  2*ph_tests <= 3*salinity_tests
constraint 2 * ph_tests <= 3 * salinity_tests;

constraint total_probes = probes_per_salinity * salinity_tests + probes_per_ph * ph_tests;

% Objective
solve minimize total_probes;