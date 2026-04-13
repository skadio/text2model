% Parameters
int: BUDGET = 1000;              % Maximum total investment units
int: costX  = 20;                % Cost coefficient for project X
int: costY  = 30;                % Cost coefficient for project Y
int: costZ  = 40;                % Cost coefficient for project Z

int: min_diff1 = 300;            % RHS for constraint: 2X - Y + Z >= 300
int: eq_rhs    = 200;            % RHS for constraint: X - 3Y - Z == 200

% Variables
var 0..BUDGET: x;                % Investment units in project X
var 0..BUDGET: y;                % Investment units in project Y
var 0..BUDGET: z;                % Investment units in project Z

% Upper bound is the maximum possible cost if all budget is spent on the most expensive project
var 0..(costX*BUDGET + costY*BUDGET + costZ*BUDGET): total_cost;

% Constraints
% Budget constraint: total investment cannot exceed available budget
constraint x + y + z <= BUDGET;

% Minimum difference constraint: 2*x - y + z must be at least the specified threshold
constraint 2 * x - y + z >= min_diff1;

% Equality constraint: x - 3*y - z must match the given RHS exactly
constraint x - 3 * y - z = eq_rhs;

% Total cost calculation constraint: define total_cost from decision variables and unit costs
constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;

% Output
output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];