% Parameters
int: total_acres = 300;

int: oil_small_per_acre = 2;
int: oil_large_per_acre = 5;

int: pollution_small_per_acre = 10;
int: pollution_large_per_acre = 20;
int: pollution_max = 4500;

int: bits_small_per_acre = 5;
int: bits_large_per_acre = 10;
int: bits_max = 2500;

% Variables
var 0..total_acres: acres_small;
var 0..total_acres: acres_large;

var 0..(oil_small_per_acre * total_acres + oil_large_per_acre * total_acres): total_oil;

% Constraints
constraint acres_small + acres_large <= total_acres;

constraint bits_small_per_acre * acres_small + bits_large_per_acre * acres_large <= bits_max;

constraint pollution_small_per_acre * acres_small + pollution_large_per_acre * acres_large <= pollution_max;

constraint total_oil = oil_small_per_acre * acres_small + oil_large_per_acre * acres_large;

% Objective
solve maximize total_oil;