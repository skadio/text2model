% Parameters
int: costX = 5000;
int: costY = 8000;

int: max_total_units = 100;
int: min_diff_X_over_Y = 20;
int: max_portfolio_units = 150;

% Variables
var 0..max_total_units: X;
var 0..max_total_units: Y;

var 0..(costX*max_total_units + costY*max_total_units): total_cost;

% Constraints
constraint X + Y <= max_total_units;
constraint X - Y >= min_diff_X_over_Y;
constraint X + 2*Y <= max_portfolio_units;

constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;