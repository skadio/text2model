% Parameters
int: total_ingredients = 1000;
int: ing_large = 3;
int: fill_large = 2;
int: ing_small = 2;
int: fill_small = 1;

int: min_large = 100;
int: min_small_pct = 60; % percent

% Variables
var 0..total_ingredients div ing_large: x_large;
var 0..total_ingredients div ing_small: x_small;

var 0..(fill_large*(total_ingredients div ing_large) + fill_small*(total_ingredients div ing_small)): total_filler;

% Constraints
constraint ing_large * x_large + ing_small * x_small <= total_ingredients;

constraint x_large >= min_large;

% At least 60% of total pills are small:
% x_small / (x_large + x_small) >= 0.60  <=>  5*x_small >= 3*(x_large + x_small)  <=>  2*x_small >= 3*x_large
constraint 2 * x_small >= 3 * x_large;

constraint total_filler = fill_large * x_large + fill_small * x_small;

% Objective
solve minimize total_filler;