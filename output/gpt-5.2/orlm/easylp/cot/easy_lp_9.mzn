% Parameters (with values embedded)
int: budget = 5000;
int: impact_required = 20000;

int: impact_X = 10;
int: impact_Y = 30;

int: cost_X = 50;
int: cost_Y = 60;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..(cost_X*budget + cost_Y*budget): total_cost;

% Constraints
constraint X + Y <= budget;
constraint impact_X * X + impact_Y * Y >= impact_required;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;