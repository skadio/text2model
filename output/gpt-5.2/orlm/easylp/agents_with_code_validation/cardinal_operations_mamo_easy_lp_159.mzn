% Parameters
% Embedded directly from the problem statement (no .dzn file needed)
int: max_total_units = 1000;            % X + Y <= 1000
int: min_diversity_units = 500;         % 2*X + Y >= 500
int: max_difference_units = 200;        % |X - Y| <= 200

int: cost_X = 200;                      % $ per unit of X
int: cost_Y = 300;                      % $ per unit of Y


% Variables
% Decision variables: integer, nonnegative numbers of units
var 0..max_total_units: units_X;
var 0..max_total_units: units_Y;

% Total cost (upper bound is a safe worst-case if both hit max_total_units)
var 0..(cost_X*max_total_units + cost_Y*max_total_units): total_cost;


% Constraints
% --- Total units capacity constraint ---
constraint units_X + units_Y <= max_total_units;

% --- Portfolio diversity constraint ---
constraint 2 * units_X + units_Y >= min_diversity_units;

% --- Overexposure / balance constraint ---
constraint abs(units_X - units_Y) <= max_difference_units;

% --- Total cost definition constraint ---
constraint total_cost = cost_X * units_X + cost_Y * units_Y;


% Objective
solve minimize total_cost;