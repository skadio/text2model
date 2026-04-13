% Parameters
int: cost_x = 10;              % Production cost per unit of product X ($)
int: cost_y = 15;              % Production cost per unit of product Y ($)

int: demand_a_x = 2;           % Demand constraint coefficient for X
int: demand_a_y = 3;           % Demand constraint coefficient for Y
int: demand_min = 40;          % Minimum required demand level

int: cap_a_x = 5;              % Capacity constraint coefficient for X
int: cap_a_y = 4;              % Capacity constraint coefficient for Y
int: cap_max = 100;            % Maximum allowed capacity level

% Safe upper bounds for decision variables (non-negative integers)
int: max_x = cap_max div cap_a_x;   % If Y=0, max X from capacity: 5X <= 100 => X<=20
int: max_y = cap_max div cap_a_y;   % If X=0, max Y from capacity: 4Y <= 100 => Y<=25

% Variables
var 0..max_x: x;               % Units of product X to produce (integer, non-negative)
var 0..max_y: y;               % Units of product Y to produce (integer, non-negative)

var 0..(cost_x*max_x + cost_y*max_y): total_cost;  % Total cost ($), bounded

% Constraints
% Define total cost from decision variables
constraint total_cost = cost_x * x + cost_y * y;

% Demand satisfaction: ensure production meets minimum required demand level
constraint demand_a_x * x + demand_a_y * y >= demand_min;

% Capacity limit: ensure production stays within maximum allowed capacity level
constraint cap_a_x * x + cap_a_y * y <= cap_max;

% Objective
solve minimize total_cost;