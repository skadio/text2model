% Parameters (with values embedded)
int: total_budget = 100;
int: impact_X = 3;
int: impact_Y = 4;
int: min_impact = 300;
int: max_diff = 20;
int: cost_X = 5;
int: cost_Y = 2;

% Variables
var 0..total_budget: X;
var 0..total_budget: Y;
var 0..(cost_X*total_budget + cost_Y*total_budget): total_cost;

% Constraints
constraint X + Y <= total_budget;
constraint impact_X * X + impact_Y * Y >= min_impact;
constraint abs(X - Y) <= max_diff;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;