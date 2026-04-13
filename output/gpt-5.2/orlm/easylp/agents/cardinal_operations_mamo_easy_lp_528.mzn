% Parameters
% Embedded constants (no external .dzn expected)
int: total_budget = 1000;          % Maximum total allocation across X,Y,Z
int: min_diff_XY = 50;             % X must be at least 50 more than Y (X - Y >= 50)
int: max_abs_diff_ZX = 200;        % |Z - X| <= 200
int: min_sum_YZ = 400;             % Y + Z >= 400

int: cost_X = 2;                   % Cost per unit in department X
int: cost_Y = 3;                   % Cost per unit in department Y
int: cost_Z = 4;                   % Cost per unit in department Z


% Variables
var 0..total_budget: alloc_X;      % Integer units allocated to department X
var 0..total_budget: alloc_Y;      % Integer units allocated to department Y
var 0..total_budget: alloc_Z;      % Integer units allocated to department Z

% Total cost upper bound uses worst-case all budget spent in each department (safe bound)
var 0..(cost_X*total_budget + cost_Y*total_budget + cost_Z*total_budget): total_cost;


% Constraints
% Budget limit: total allocation across departments cannot exceed the total budget
constraint alloc_X + alloc_Y + alloc_Z <= total_budget;

% Department relationship: X must be at least min_diff_XY units more than Y
constraint alloc_X - alloc_Y >= min_diff_XY;

% Balance constraint: allocation difference between Z and X bounded by max_abs_diff_ZX
constraint abs(alloc_Z - alloc_X) <= max_abs_diff_ZX;

% Minimum stocking requirement: combined allocation for Y and Z must be at least min_sum_YZ
constraint alloc_Y + alloc_Z >= min_sum_YZ;

% Total cost definition (integer linear expression)
constraint total_cost = cost_X * alloc_X + cost_Y * alloc_Y + cost_Z * alloc_Z;


% Objective
solve minimize total_cost;