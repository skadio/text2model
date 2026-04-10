% Parameters
int: min_total_investment = 30;
int: max_resource_usage = 150;

int: usage_X = 5;
int: usage_Y = 3;

int: cost_X = 40;
int: cost_Y = 50;

int: maxX = max_resource_usage div usage_X; % safe upper bound
int: maxY = max_resource_usage div usage_Y; % safe upper bound

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..(cost_X*maxX + cost_Y*maxY): total_cost;

% Constraints
constraint X + Y >= min_total_investment;
constraint usage_X * X + usage_Y * Y <= max_resource_usage;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;