% Parameters
% All data is embedded directly in the model as requested.

int: max_total_alloc = 1000;          % x + y + z <= 1000
int: min_strength = 400;              % 2*x + y >= 400
int: max_yz_alloc = 600;              % y + z <= 600

int: cost_x = 4;                      % cost per unit of X
int: cost_y = 3;                      % cost per unit of Y
int: cost_z = 5;                      % cost per unit of Z


% Variables
var 0..max_total_alloc: x;            % allocation to unit X (integer, nonnegative)
var 0..max_total_alloc: y;            % allocation to unit Y (integer, nonnegative)
var 0..max_total_alloc: z;            % allocation to unit Z (integer, nonnegative)

% Upper bound: all 1000 units assigned at the maximum unit cost (5) => 5000
var 0..(cost_z * max_total_alloc): total_cost;


% Constraints
% --- Total allocation capacity constraint ---
constraint x + y + z <= max_total_alloc;

% --- Minimum combined strength requirement ---
constraint 2 * x + y >= min_strength;

% --- Balanced deployment limit for units Y and Z ---
constraint y + z <= max_yz_alloc;

% --- Total cost definition ---
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;


% Objective
solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];