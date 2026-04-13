% Parameters
int: max_units = 1000;
int: min_diversity = 500;        % 2*X + Y >= 500
int: max_diff = 200;             % |X - Y| <= 200
int: cost_x = 200;
int: cost_y = 300;

% Variables
var 0..max_units: X;
var 0..max_units: Y;
var 0..(cost_x*max_units + cost_y*max_units): total_cost;

% Constraints
constraint X + Y <= max_units;
constraint 2*X + Y >= min_diversity;
constraint abs(X - Y) <= max_diff;

constraint total_cost = cost_x*X + cost_y*Y;

% Objective
solve minimize total_cost;