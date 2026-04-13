% Parameters
int: nCenters = 7;
set of int: CENTERS = 1..nCenters;

array[CENTERS] of int: initial_supply = [97, 458, 473, 380, 34, 399, 163];
array[CENTERS] of int: required_supply = [119, 275, 36, 459, 17, 128, 425];

% Transfer cost from i to j
array[CENTERS, CENTERS] of int: cost =
array2d(CENTERS, CENTERS,
[
  0, 41, 42, 31, 39,  2, 18,   % from 1
 48,  0,  9, 22, 47, 29, 39,   % from 2
 36, 22,  0, 29, 45, 33, 45,   % from 3
 19,  5, 10,  0,  3, 42, 20,   % from 4
 13, 10, 21,  7,  0, 35, 11,   % from 5
  5, 35, 29, 16, 40,  0,  9,   % from 6
  7, 24, 26, 38, 33, 13,  0    % from 7
]);

int: total_initial = sum(i in CENTERS)(initial_supply[i]);
int: total_required = sum(i in CENTERS)(required_supply[i]);
int: max_transfer = total_initial;

% Variables
array[CENTERS, CENTERS] of var 0..max_transfer: ship;
var int: total_cost;

% Constraints
constraint forall(i in CENTERS)(ship[i,i] = 0);

constraint total_initial >= total_required;

constraint forall(c in CENTERS)(
  initial_supply[c]
  + sum(i in CENTERS)(ship[i,c])
  - sum(j in CENTERS)(ship[c,j])
  = required_supply[c]
);

constraint forall(i in CENTERS)(
  sum(j in CENTERS)(ship[i,j]) <= initial_supply[i]
);

constraint total_cost = sum(i in CENTERS, j in CENTERS)(cost[i,j] * ship[i,j]);

% Objective
solve minimize total_cost;