% Parameters
int: nFactories = 2;
set of int: F = 1..nFactories;

int: nColors = 3;
set of int: C = 1..nColors;

int: BLACK = 1;
int: WHITE = 2;
int: BROWN = 3;

array[F] of int: cost_per_hour = [300, 600];

array[F, C] of int: prod_per_hour =
  [|  5,  6,  3   % Factory 1: black, white, brown
   | 10, 10,  0   % Factory 2: black, white, brown
  |];

array[C] of int: demand = [20, 5, 15];

% Variables
array[F] of var 0..1000: hours;  % hours run per day (bounded sufficiently)

var 0..1000000: total_cost;

% Constraints
constraint
  forall(c in C) (
    sum(f in F) (prod_per_hour[f, c] * hours[f]) >= demand[c]
  );

constraint
  total_cost = sum(f in F) (cost_per_hour[f] * hours[f]);

% Objective
solve minimize total_cost;