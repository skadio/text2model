% Parameters
int: n_products = 2;
set of int: P = 1..n_products;

array[P] of float: assembly_per_unit = [1.0/4.0, 1.0/3.0];
array[P] of float: testing_per_unit  = [1.0/8.0, 1.0/3.0];
array[P] of float: raw_cost_per_unit = [1.2, 0.9];
array[P] of float: market_value      = [9.0, 8.0];

float: assembly_regular_cap = 90.0;
float: testing_cap = 80.0;

float: overtime_assembly_cap = 50.0;
float: overtime_cost_per_hour = 7.0;

% Scaling to avoid floats (hours in 24ths; money in 10ths of dollars)
int: hour_scale = 24;
array[P] of int: assembly24 = [6, 8];   % 1/4*24=6, 1/3*24=8
array[P] of int: testing24  = [3, 8];   % 1/8*24=3, 1/3*24=8

int: assembly_regular_cap24 = 90 * hour_scale;
int: testing_cap24 = 80 * hour_scale;
int: overtime_assembly_cap24 = 50 * hour_scale;

int: money_scale = 10;
array[P] of int: raw_cost10 = [12, 9];
array[P] of int: value10    = [90, 80];
int: overtime_cost10_per_hour = 70; % $7.0 -> 70 tenths

% Variables
array[P] of var 0..1000000: x;          % units produced
var 0..overtime_assembly_cap24: overtime24;

% Profit in tenths of dollars (can be negative only if forced, but production is optional)
var int: profit10;

% Constraints
constraint
  sum(p in P)(assembly24[p] * x[p]) <= assembly_regular_cap24 + overtime24;

constraint
  sum(p in P)(testing24[p] * x[p]) <= testing_cap24;

constraint
  profit10 =
    sum(p in P)((value10[p] - raw_cost10[p]) * x[p])
    - overtime_cost10_per_hour * (overtime24 div hour_scale);

% Objective
solve maximize profit10;