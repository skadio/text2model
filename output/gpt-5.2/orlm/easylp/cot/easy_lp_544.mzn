% Parameters (with values embedded)
int: n = 3;
set of int: TASKS = 1..n;

array[TASKS] of int: prod = [8, 5, 6]; % productivity score per hour

% Upper bounds for hours on each task
array[TASKS] of int: ub = [30, 20, 15];

% Variables
array[TASKS] of var 0..30: x; % hours for tasks x1,x2,x3 (integer)

% Constraints
constraint forall(i in TASKS) (x[i] <= ub[i]);

% 2*x1 + 4*x2 + 3*x3 <= 40
constraint 2*x[1] + 4*x[2] + 3*x[3] <= 40;

% x1 + (1/2)x2 - (1/4)x3 >= 10  ->  4*x1 + 2*x2 - x3 >= 40
constraint 4*x[1] + 2*x[2] - x[3] >= 40;

% 2.5*x2 - (x1 + 0.75*x3) <= -20  ->  10*x2 - 4*x1 - 3*x3 <= -80
constraint 10*x[2] - 4*x[1] - 3*x[3] <= -80;

% Objective
var int: total_productivity = sum(i in TASKS)(prod[i] * x[i]);

solve minimize total_productivity;