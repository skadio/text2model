% Florist bouquet transport optimization
include "globals.mzn";

% Data (embedded as required)
int: flowers_small = 5;
int: flowers_large = 10;

int: max_small = 80;
int: max_large = 50;
int: max_total_bouquets = 70;

int: min_large = 20;
int: small_at_least_multiple = 2; % small >= 2 * large

% Decision variables
var 0..max_small: small;
var 0..max_large: large;

% Constraints
constraint small + large <= max_total_bouquets;
constraint large >= min_large;
constraint small >= small_at_least_multiple * large;

% Objective: maximize total flowers delivered
var int: total_flowers = flowers_small * small + flowers_large * large;

solve maximize total_flowers;

output [
  "small = ", show(small), "\n",
  "large = ", show(large), "\n",
  "total_bouquets = ", show(small + large), "\n",
  "total_flowers = ", show(total_flowers), "\n"
];