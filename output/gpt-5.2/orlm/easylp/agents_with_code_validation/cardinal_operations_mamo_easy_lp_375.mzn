% Parameters
% Hiring cost per employee in each department
int: cost_x1 = 50;
int: cost_x2 = 70;
int: cost_x3 = 90;
int: cost_x4 = 110;

% Upper bounds (capacity/limit) on employees per department
int: ub_x1 = 20;
int: ub_x2 = 15;
int: ub_x3 = 10;
int: ub_x4 = 5;

% Pairwise combined upper bounds
int: ub_x1_x2 = 40;
int: ub_x2_x3 = 30;
int: ub_x3_x4 = 20;

% Constraint parameter for: x1 >= 0.5*x4 + 10  ->  2*x1 >= x4 + 20
int: extra_x1 = 10;


% Variables
% Number of employees assigned to each department (whole numbers)
var 0..ub_x1: x1;
var 0..ub_x2: x2;
var 0..ub_x3: x3;
var 0..ub_x4: x4;

% Total hiring cost (bounded for safe linear usage)
var 0..(cost_x1*ub_x1 + cost_x2*ub_x2 + cost_x3*ub_x3 + cost_x4*ub_x4): total_cost;


% Constraints
% --- Pairwise combined staffing limits (budget/space constraints) ---
constraint x1 + x2 <= ub_x1_x2;
constraint x2 + x3 <= ub_x2_x3;
constraint x3 + x4 <= ub_x3_x4;

% --- Minimum staffing relationship between x1 and x4 ---
% Avoid fractional arithmetic by multiplying through by 2:
% x1 >= 0.5*x4 + extra_x1  <=>  2*x1 >= x4 + 2*extra_x1
constraint 2 * x1 >= x4 + 2 * extra_x1;

% --- Total cost definition ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;