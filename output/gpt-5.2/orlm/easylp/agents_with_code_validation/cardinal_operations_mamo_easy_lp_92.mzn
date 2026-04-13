% Parameters
int: cost_x = 10;              % Production cost per unit of product X ($)
int: cost_y = 15;              % Production cost per unit of product Y ($)

int: demand_a_x = 2;           % Coefficient of X in demand constraint
int: demand_a_y = 3;           % Coefficient of Y in demand constraint
int: demand_min = 40;          % Minimum required weighted demand

int: cap_a_x = 5;              % Coefficient of X in capacity constraint
int: cap_a_y = 4;              % Coefficient of Y in capacity constraint
int: cap_max = 100;            % Maximum allowed weighted capacity

% Variable upper bounds derived from nonnegativity and capacity:
% 5*x + 4*y <= 100 => x <= 20, y <= 25
int: x_ub = cap_max div cap_a_x;  % 100 div 5 = 20
int: y_ub = cap_max div cap_a_y;  % 100 div 4 = 25

% Variables
var 0..x_ub: x;               % Units of product X to produce (integer, nonnegative)
var 0..y_ub: y;               % Units of product Y to produce (integer, nonnegative)

var 0..(cost_x * x_ub + cost_y * y_ub): total_cost;  % Total cost ($), bounded

% Constraints

% Link total_cost to production quantities and unit costs
constraint
  total_cost = cost_x * x + cost_y * y;

% Demand satisfaction: produce enough to meet minimum weighted demand
constraint
  demand_a_x * x + demand_a_y * y >= demand_min;

% Capacity limit: do not exceed maximum weighted production capacity
constraint
  cap_a_x * x + cap_a_y * y <= cap_max;

% Objective
solve minimize total_cost;