% Parameters
int: n = 3;
set of int: TASKS = 1..n;

array[TASKS] of int: prod = [8, 5, 6];

% Coefficients scaled by 4 to avoid fractions
% Constraint 1: 2*x1 + 4*x2 + 3*x3 <= 40  --> scaled by 4
array[TASKS] of int: c1 = [8, 16, 12];
int: rhs1 = 160;

% Constraint 2: x1 + (1/2)*x2 - (1/4)*x3 >= 10  --> scaled by 4
array[TASKS] of int: c2 = [4, 2, -1];
int: rhs2 = 40;

% Constraint 3: (5/2)*x2 - x1 - (3/4)*x3 <= -20  --> scaled by 4
array[TASKS] of int: c3 = [-4, 10, -3];
int: rhs3 = -80;

array[TASKS] of int: ub = [30, 20, 15];

% Variables
array[TASKS] of var 0..30: x;
var 0..(8*30 + 5*20 + 6*15): total_prod;

% Constraints
constraint forall(i in TASKS) (x[i] <= ub[i]);

constraint sum(i in TASKS)(c1[i] * x[i]) <= rhs1;
constraint sum(i in TASKS)(c2[i] * x[i]) >= rhs2;
constraint sum(i in TASKS)(c3[i] * x[i]) <= rhs3;

constraint total_prod = sum(i in TASKS)(prod[i] * x[i]);

% Objective
solve minimize total_prod;