% Parameters
int: budget = 1000;                 % Maximum total investment available
int: min_extra_X_over_2Y = 200;     % X must be at least 2*Y + 200
int: min_extra_Z_over_Y = 100;      % Z must be at least Y + 100

int: costX = 10;                    % Cost per unit invested in X
int: costY = 15;                    % Cost per unit invested in Y
int: costZ = 20;                    % Cost per unit invested in Z

% Variables
var 0..budget: x;                   % Integer investment in project X
var 0..budget: y;                   % Integer investment in project Y
var 0..budget: z;                   % Integer investment in project Z

% Upper bound: worst-case if all budget went to each (loose but safe)
var 0..(costX*budget + costY*budget + costZ*budget): total_cost;

% Constraints
% Budget constraint: total investment across projects cannot exceed available budget
constraint x + y + z <= budget;

% Project relationship constraints: enforce minimum relative allocations
constraint x >= 2 * y + min_extra_X_over_2Y;
constraint z >= y + min_extra_Z_over_Y;

% Total cost definition: link total_cost to per-unit costs and investments
constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;