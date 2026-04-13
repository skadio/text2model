% Parameters
int: budget = 5000;

int: minEff12 = 1000;     % 5*x1 - 2.5*x2 >= 1000
int: maxEff23 = 4000;     % 3*x2 + 4.5*x3 <= 4000

int: c1 = 10;
int: c2 = 20;
int: c3 = 30;

% Variables
var 0..budget: x1;
var 0..budget: x2;
var 0..budget: x3;

var 0..(c1*budget + c2*budget + c3*budget): total_cost;

% Constraints
constraint x1 + x2 + x3 <= budget;

% Scale by 2 to avoid fractions:
% 5*x1 - 2.5*x2 >= 1000  <=>  10*x1 - 5*x2 >= 2000
constraint 10*x1 - 5*x2 >= 2*minEff12;

% 3*x2 + 4.5*x3 <= 4000  <=>  6*x2 + 9*x3 <= 8000
constraint 6*x2 + 9*x3 <= 2*maxEff23;

% Balance: x1 - 1.5*x2 = x3  <=>  2*x1 - 3*x2 = 2*x3
constraint 2*x1 - 3*x2 = 2*x3;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;