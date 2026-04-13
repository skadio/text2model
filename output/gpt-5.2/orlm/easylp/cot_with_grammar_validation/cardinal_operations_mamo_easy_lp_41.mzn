% Parameters
int: budget = 10000;
int: minX = 2000;
int: minY = 3000;

% Costs per dollar invested (in cents to keep integrality)
int: costX_cents_per_dollar = 2;  % $0.02 = 2 cents
int: costY_cents_per_dollar = 3;  % $0.03 = 3 cents

% Variables
var minX..budget: x;
var minY..budget: y;
var 0..(costX_cents_per_dollar*budget + costY_cents_per_dollar*budget): total_cost_cents;

% Constraints
constraint x + y <= budget;

constraint total_cost_cents = costX_cents_per_dollar * x + costY_cents_per_dollar * y;

% Objective
solve minimize total_cost_cents;