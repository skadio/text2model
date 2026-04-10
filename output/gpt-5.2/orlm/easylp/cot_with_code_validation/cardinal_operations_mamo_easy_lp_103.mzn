% Parameters
int: min_total_hires = 10;
int: max_weighted_hires = 20;         % constraint: 2*X + Y <= 20
int: cost_X = 50;
int: cost_Y = 30;

% Variables
var 0..max_weighted_hires: X;
var 0..max_weighted_hires: Y;
var 0..(cost_X*max_weighted_hires + cost_Y*max_weighted_hires): total_cost;

% Constraints
constraint X + Y >= min_total_hires;
constraint 2*X + Y <= max_weighted_hires;

constraint total_cost = cost_X*X + cost_Y*Y;

% Objective
solve minimize total_cost;