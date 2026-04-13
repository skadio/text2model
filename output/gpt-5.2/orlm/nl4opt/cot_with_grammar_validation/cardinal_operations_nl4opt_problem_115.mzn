% Parameters
int: nFactories = 2;
int: nColors = 3;

set of int: F = 1..nFactories;
set of int: C = 1..nColors;

int: BLACK = 1;
int: WHITE = 2;
int: BROWN = 3;

array[F] of int: cost_per_hour = [300, 600];

array[F, C] of int: prod_per_hour =
  array2d(F, C, [
    5,  6,  3,   % factory 1: black, white, brown
    10, 10, 0    % factory 2: black, white, brown
  ]);

array[C] of int: demand_min = [20, 5, 15];

int: maxHours = max([ max(demand_min[cc], 0) | cc in C ]);  % safe upper bound

% Variables
array[F] of var 0..maxHours: hours;

% Constraints
constraint forall(cc in C) (
  sum(ff in F)(prod_per_hour[ff, cc] * hours[ff]) >= demand_min[cc]
);

% Objective
solve minimize sum(ff in F)(cost_per_hour[ff] * hours[ff]);