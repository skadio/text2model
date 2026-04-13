% Parameters
int: total_acres = 300;
int: max_drill_bits = 2500;
int: max_pollution = 4500;

int: oil_small = 2;        % barrels per acre
int: oil_large = 5;        % barrels per acre

int: poll_small = 10;      % units per acre
int: poll_large = 20;      % units per acre

int: bits_small = 5;       % drill bits per acre
int: bits_large = 10;      % drill bits per acre

% Variables
var 0..total_acres: acres_small;
var 0..total_acres: acres_large;
var 0..(oil_large * total_acres): total_oil;

% Constraints
constraint acres_small + acres_large <= total_acres;

constraint bits_small * acres_small + bits_large * acres_large <= max_drill_bits;

constraint poll_small * acres_small + poll_large * acres_large <= max_pollution;

constraint total_oil = oil_small * acres_small + oil_large * acres_large;

% Objective
solve maximize total_oil;