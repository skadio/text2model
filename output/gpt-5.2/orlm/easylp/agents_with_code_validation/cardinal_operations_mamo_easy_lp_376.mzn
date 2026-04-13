% Parameters
% Department index set
set of int: DEPTS = 1..4;
int: X = 1;
int: Y = 2;
int: Z = 3;
int: W = 4;

% Manpower requirement / capacity parameters
int: max_XY = 50;      % X + Y <= 50
int: min_X  = 20;      % X >= 20
int: max_Y  = 30;      % Y <= 30

% Cost per employee, scaled by 2 to keep integer arithmetic:
% 1.5 -> 3, 2 -> 4, 3 -> 6, 4 -> 8
array[DEPTS] of int: cost2 = [3, 4, 6, 8];

% Variables
% Integer headcount per department (indivisible employees)
array[DEPTS] of var int: employees;

% Total cost scaled by 2
var int: total_cost2 = sum(d in DEPTS)(cost2[d] * employees[d]);

% Constraints
% Domain / non-negativity constraints
constraint
  forall(d in DEPTS) (
    employees[d] >= 0
  );

% Budget / combined headcount limit for departments X and Y
constraint
  employees[X] + employees[Y] <= max_XY;

% Minimum staffing requirement for department X
constraint
  employees[X] >= min_X;

% Capacity (upper bound) for department Y
constraint
  employees[Y] <= max_Y;

% Department X must be at least as large as departments Z and W combined
% (Z + W - X <= 0  <=>  Z + W <= X)
constraint
  employees[Z] + employees[W] <= employees[X];

% Objective
solve minimize total_cost2;

output [
  "employees_X=", show(employees[X]), "\n",
  "employees_Y=", show(employees[Y]), "\n",
  "employees_Z=", show(employees[Z]), "\n",
  "employees_W=", show(employees[W]), "\n",
  "total_cost_exact=", show(total_cost2), "/2\n",
  "total_cost_rounded=", show((total_cost2 + 1) div 2), "\n"
];