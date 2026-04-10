% Parameters
int: budget = 1000;              % Maximum total allocation allowed
int: min_excess_X_over_2Y = 200; % X must be at least (2*Y + 200)
int: min_excess_Z_over_Y = 100;  % Z must be at least (Y + 100)

int: costX = 2;                  % Cost per unit allocated to X
int: costY = 3;                  % Cost per unit allocated to Y
int: costZ = 1;                  % Cost per unit allocated to Z

% Variables
var 0..budget: x;                % Allocation to project X (whole units)
var 0..budget: y;                % Allocation to project Y (whole units)
var 0..budget: z;                % Allocation to project Z (whole units)

% Total cost upper bound is the worst-case if each variable could independently hit budget
var 0..(costX*budget + costY*budget + costZ*budget): total_cost;

% Constraints
% Budget constraint: total allocation across projects cannot exceed the available budget
constraint x + y + z <= budget;

% Project relationship constraints: enforce minimum excess requirements between allocations
constraint x >= 2 * y + min_excess_X_over_2Y;
constraint z >= y + min_excess_Z_over_Y;

% Total cost definition: compute total cost from per-unit costs and allocations
constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;