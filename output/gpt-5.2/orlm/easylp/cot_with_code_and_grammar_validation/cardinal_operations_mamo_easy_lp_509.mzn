% Parameters
int: BUDGET = 1000;
int: RHS1 = 200;     % 2*x1 - 3*x2 >= 200
int: RHS2 = 300;     % x1 - 0.5*x3 <= 300  ->  2*x1 - x3 <= 600
int: RHS3 = -500;    % 2.5*x2 - x1 - x3 >= -500 -> 5*x2 - 2*x1 - 2*x3 >= -1000

int: c1 = 50;
int: c2 = 60;
int: c3 = 70;

% Variables
var 0..BUDGET: x1;
var 0..BUDGET: x2;
var 0..BUDGET: x3;

var 0..(c1*BUDGET + c2*BUDGET + c3*BUDGET): total_cost;

% Constraints
constraint x1 + x2 + x3 <= BUDGET;

constraint 2*x1 - 3*x2 >= RHS1;

% x1 <= 300 + 0.5*x3  =>  2*x1 - x3 <= 600
constraint 2*x1 - x3 <= 2*RHS2;

% 2.5*x2 - x1 - x3 >= -500  =>  5*x2 - 2*x1 - 2*x3 >= -1000
constraint 5*x2 - 2*x1 - 2*x3 >= 2*RHS3;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;