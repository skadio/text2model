% Parameters
int: cost_x = 20;                % Cost per unit of product category X
int: cost_y = 30;                % Cost per unit of product category Y

int: max_total_inventory = 500;  % Storage limit on combined inventory (X + Y)

int: demand_min = 1000;          % Minimum required combined effect: 3*X + 2*Y >= 1000
int: coef_x_demand = 3;          % Coefficient of X in combined effect constraint
int: coef_y_demand = 2;          % Coefficient of Y in combined effect constraint

int: coef_x_rel = 4;             % Coefficient of X in relationship constraint
int: rel_slack = 600;            % Slack allowed: 4*X <= Y + 600

int: max_x = 400;                % Upper bound on units of X
int: max_y = 300;                % Upper bound on units of Y

% Variables
var 0..max_x: x_units;           % Inventory level for product category X (integer, non-negative)
var 0..max_y: y_units;           % Inventory level for product category Y (integer, non-negative)

var 0..(cost_x*max_x + cost_y*max_y): total_cost;  % Total carrying cost (bounded for linear expressions)

% Constraints
% Link total cost to decision variables (linear cost definition)
constraint
  total_cost = cost_x * x_units + cost_y * y_units;

% Storage capacity: combined inventory cannot exceed storage limit
constraint
  x_units + y_units <= max_total_inventory;

% Demand/diversity requirement: combined effect must meet minimum level
constraint
  coef_x_demand * x_units + coef_y_demand * y_units >= demand_min;

% Relationship constraint: 4*X cannot exceed Y by more than the allowed slack
constraint
  coef_x_rel * x_units <= y_units + rel_slack;

% Objective
solve minimize total_cost;