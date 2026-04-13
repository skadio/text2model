include "globals.mzn";

% Data (embedded)
int: slices_manual = 5;
int: slices_auto   = 8;
int: grease_manual = 3;
int: grease_auto   = 6;

int: min_slices = 50;
int: max_grease = 35;

% Decision variables: number of slicers to buy
var 0..100: m;  % manual slicers
var 0..100: a;  % automatic slicers

% Constraints
constraint slices_manual * m + slices_auto * a >= min_slices;
constraint grease_manual * m + grease_auto * a <= max_grease;
constraint m < a;

% Objective: minimize total number of slicers
var 0..200: total = m + a;
solve minimize total;

output [
  "manual = ", show(m), "\n",
  "automatic = ", show(a), "\n",
  "total = ", show(total), "\n",
  "slices_per_min = ", show(slices_manual*m + slices_auto*a), "\n",
  "grease_per_min = ", show(grease_manual*m + grease_auto*a), "\n"
];