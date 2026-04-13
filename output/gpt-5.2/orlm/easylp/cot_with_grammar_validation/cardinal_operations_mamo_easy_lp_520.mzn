% Parameters
int: budget = 10000;
int: c1 = 500;
int: c2 = 400;
int: c3 = 300;

int: rhs1 = 2000;      % 0.5*x1 - 0.25*x2 >= 2000
int: diff_max = 500;   % x3 - x1 <= 500

% Variables
var 0..budget: x1;
var 0..budget: x2;
var 0..budget: x3;

var 0..(c1*budget + c2*budget + c3*budget): total_cost;

% Constraints
constraint c1*x1 + c2*x2 + c3*x3 <= budget;

% Multiply by 4 to avoid fractions: 2*x1 - x2 >= 8000
constraint 2*x1 - x2 >= 4*rhs1;

constraint x3 - x1 <= diff_max;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;