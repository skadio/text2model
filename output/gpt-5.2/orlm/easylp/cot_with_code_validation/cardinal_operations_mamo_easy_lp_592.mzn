% Parameters
int: cap12 = 300;
int: cap34 = 500;
int: rhs3 = 100;
int: rhs4 = 200;

% Scale all costs/coefficients by 10 to keep everything integer:
% cost: [0.5,0.6,0.8,1.2] -> [5,6,8,12]
% constraint3: 0.7*x2 - x1 - x3 + 0.9*x4 >= 100
%          -> 7*x2 - 10*x1 - 10*x3 + 9*x4 >= 1000
% constraint4: (x3 - 0.8*x4) - (x1 + x2) <= 200
%          -> 10*x3 - 8*x4 - 10*x1 - 10*x2 <= 2000

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

var 0..(12*cap12 + 12*cap12 + 12*cap34 + 12*cap34): total_cost10;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint 7*x2 - 10*x1 - 10*x3 + 9*x4 >= 10*rhs3;

constraint 10*x3 - 8*x4 - 10*x1 - 10*x2 <= 10*rhs4;

constraint total_cost10 = 5*x1 + 6*x2 + 8*x3 + 12*x4;

% Objective
solve minimize total_cost10;