% Parameters (with values embedded)
int: total_acres = 300;
int: oil_small_per_acre = 2;
int: oil_large_per_acre = 5;

int: pollution_small_per_acre = 10;
int: pollution_large_per_acre = 20;
int: max_pollution = 4500;

int: bits_small_per_acre = 5;
int: bits_large_per_acre = 10;
int: max_bits = 2500;

% Variables
var 0..total_acres: acres_small;
var 0..total_acres: acres_large;

% Constraints
constraint acres_small + acres_large <= total_acres;

constraint bits_small_per_acre * acres_small + bits_large_per_acre * acres_large <= max_bits;

constraint pollution_small_per_acre * acres_small + pollution_large_per_acre * acres_large <= max_pollution;

% Objective
var int: total_oil = oil_small_per_acre * acres_small + oil_large_per_acre * acres_large;

solve maximize total_oil;

output [
  "acres_small = ", show(acres_small), "\n",
  "acres_large = ", show(acres_large), "\n",
  "total_oil = ", show(total_oil), "\n"
];