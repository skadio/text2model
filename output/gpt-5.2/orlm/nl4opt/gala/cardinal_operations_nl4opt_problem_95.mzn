% Dog hospital bone production (all data embedded)

include "globals.mzn";

% Parameters
int: total_med = 2000;

int: med_small = 10;
int: meat_small = 12;

int: med_large = 15;
int: meat_large = 15;

int: min_large = 30;

% Decision variables: number of bones
var 0..total_med div med_small: small;
var 0..total_med div med_large: large;

% Constraints
constraint med_small * small + med_large * large <= total_med;
constraint large >= min_large;

% At least 50% small: small >= 0.5*(small+large)  <=>  small >= large
constraint small >= large;

% Objective: minimize total meat used
var 0..(meat_small*(total_med div med_small) + meat_large*(total_med div med_large)): total_meat =
  meat_small * small + meat_large * large;

solve minimize total_meat;

output [
  "small = ", show(small), "\n",
  "large = ", show(large), "\n",
  "total_meat = ", show(total_meat), "\n",
  "total_med_used = ", show(med_small*small + med_large*large), "\n"
];