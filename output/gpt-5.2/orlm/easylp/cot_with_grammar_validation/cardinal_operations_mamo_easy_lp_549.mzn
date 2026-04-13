% Parameters
int: budget = 5000;
int: min_eff_x1 = 1000;
int: max_eff_x2x3 = 4000;

int: c1 = 10;
int: c2 = 20;
int: c3 = 30;

% Use integer-scaled coefficients to avoid fractions (multiply by 2)
int: k1 = 10;   % 2 * 5
int: k2a = 5;   % 2 * 2.5
int: k2b = 6;   % 2 * 3
int: k3b = 9;   % 2 * 4.5
int: rhs1 = 2 * min_eff_x1;
int: rhs2 = 2 * max_eff_x2x3;

% Variables
var 0..budget: x1;
var 0..budget: x2;
var 0..budget: x3;

var 0..(c1*budget + c2*budget + c3*budget): total_cost;

% Constraints
constraint x1 + x2 + x3 <= budget;

% 5*x1 - 2.5*x2 >= 1000  ==> 10*x1 - 5*x2 >= 2000
constraint k1*x1 - k2a*x2 >= rhs1;

% 3*x2 + 4.5*x3 <= 4000 ==> 6*x2 + 9*x3 <= 8000
constraint k2b*x2 + k3b*x3 <= rhs2;

% x1 - 1.5*x2 = x3  ==> 2*x1 - 3*x2 = 2*x3
constraint 2*x1 - 3*x2 = 2*x3;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;