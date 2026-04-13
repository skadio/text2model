% Parameters
int: n = 3;
set of int: TASKS = 1..n;

array[TASKS] of int: prod = [8, 5, 6];

int: ub1 = 30;
int: ub2 = 20;
int: ub3 = 15;

% To avoid fractions, multiply constraints by LCM 4
int: L = 4;

% Variables
array[TASKS] of var 0..30: x;

var int: obj;

% Constraints
constraint x[1] <= ub1;
constraint x[2] <= ub2;
constraint x[3] <= ub3;

% 2*x1 + 4*x2 + 3*x3 <= 40
constraint 2*x[1] + 4*x[2] + 3*x[3] <= 40;

% x1 + 0.5*x2 - 0.25*x3 >= 10  ==>  4*x1 + 2*x2 - x3 >= 40
constraint 4*x[1] + 2*x[2] - x[3] >= 40;

% 2.5*x2 - (x1 + 0.75*x3) <= -20  ==>  10*x2 - (4*x1 + 3*x3) <= -80
constraint 10*x[2] - (4*x[1] + 3*x[3]) <= -80;

constraint obj = sum(t in TASKS)(prod[t] * x[t]);

% Objective
solve minimize obj;