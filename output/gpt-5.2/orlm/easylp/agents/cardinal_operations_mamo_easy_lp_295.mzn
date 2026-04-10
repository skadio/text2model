% Parameters
% Department cost per teacher
int: cost_x = 4;
int: cost_y = 3;
int: cost_z = 2;

% Staffing constraint limits
int: max_xy = 25;     % X + Y <= 25
int: min_xz = 15;     % X + Z >= 15
int: max_yz = 20;     % Y + Z <= 20

% Variables
% Teachers allocated to each department (nonnegative integers)
var 0..max(max_xy, min_xz): x;   % teachers in Math (X)
var 0..max(max_xy, max_yz): y;   % teachers in Science (Y)
var 0..max(min_xz, max_yz): z;   % teachers in Arts (Z)

% Total cost (linear expression of decision variables)
var int: total_cost = cost_x * x + cost_y * y + cost_z * z;

% Constraints
% Staffing limits across departments (budget/availability constraints)
constraint x + y <= max_xy;   % Math + Science cannot exceed 25
constraint x + z >= min_xz;   % Math + Arts must be at least 15
constraint y + z <= max_yz;   % Science + Arts cannot exceed 20

% Objective
solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];