% Parameters (with values embedded)
int: max_total_resources = 100;
int: min_balance_requirement = 50;   % 2*X + Y >= 50
int: max_difference = 30;            % |X - Y| <= 30
int: cost_X = 2;
int: cost_Y = 3;

% Variables
var 0..max_total_resources: X;       % sourcing units (integer)
var 0..max_total_resources: Y;       % distribution units (integer)
var 0..(cost_X*max_total_resources + cost_Y*max_total_resources): total_cost;

% Constraints
constraint X + Y <= max_total_resources;
constraint 2*X + Y >= min_balance_requirement;
constraint abs(X - Y) <= max_difference;
constraint total_cost = cost_X*X + cost_Y*Y;

% Objective
solve minimize total_cost;