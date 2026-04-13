% Parameters
int: budget = 1000;                 % Total budget upper bound on X+Y+Z
int: min_extra_X = 200;             % X must be at least 2*Y + min_extra_X
int: min_extra_Z = 100;             % Z must be at least Y + min_extra_Z

int: costX = 10;                    % Cost per unit for project X
int: costY = 15;                    % Cost per unit for project Y
int: costZ = 20;                    % Cost per unit for project Z

% Variables
var 0..budget: X;                   % Integer allocation to project X
var 0..budget: Y;                   % Integer allocation to project Y
var 0..budget: Z;                   % Integer allocation to project Z

var 0..(budget * max([costX,costY,costZ])): total_cost;  % Total cost (bounded)

% Constraints
% Budget constraint: total allocation cannot exceed available budget
constraint X + Y + Z <= budget;

% Project relationship constraints: enforce minimum relative allocations
constraint X >= 2 * Y + min_extra_X;
constraint Z >= Y + min_extra_Z;

% Cost aggregation constraint: compute total cost from allocations and unit costs
constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;