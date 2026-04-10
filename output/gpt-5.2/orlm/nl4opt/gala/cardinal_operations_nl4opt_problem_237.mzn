include "globals.mzn";

% Data (embedded from problem statement)
int: cap_small = 200;
int: cap_large = 500;

int: max_small = 100;
int: max_large = 50;

int: max_total_crates = 60;
int: min_large = 10;

% Decision variables
var 0..max_small: small;
var 0..max_large: large;

% Constraints
constraint small <= max_small;
constraint large <= max_large;

constraint small + large <= max_total_crates;
constraint large >= min_large;

% At least 3 times as many small as large
constraint small >= 3 * large;

% Objective: maximize transported grapes
var int: total_grapes = cap_small * small + cap_large * large;

solve maximize total_grapes;

output [
  "small = ", show(small), "\n",
  "large = ", show(large), "\n",
  "total_crates = ", show(small + large), "\n",
  "total_grapes = ", show(total_grapes), "\n"
];