% Parameters
int: cost1 = 2;
int: cost2 = 3;
int: cost3 = 4;

int: total_cap = 1000;

int: x1_ub = 599; % manufacturing < 600
int: x2_ub = 500; % distribution <= 500
int: x3_ub = 299; % retail < 300

% Variables
var 0..x1_ub: x1;
var 0..x2_ub: x2;
var 0..x3_ub: x3;

var int: total_cost;

% Constraints
constraint x1 + x2 + x3 <= total_cap;

% 5*x1 - 0.5*x2 >= 500  ==>  10*x1 - x2 >= 1000
constraint 10 * x1 - x2 >= 1000;

% 4.5*x3 - x1 <= 450  ==>  9*x3 - 2*x1 <= 900
constraint 9 * x3 - 2 * x1 <= 900;

% x2 + 0.5*x3 - x1 >= 200  ==>  2*x2 + x3 - 2*x1 >= 400
constraint 2 * x2 + x3 - 2 * x1 >= 400;

constraint total_cost = cost1 * x1 + cost2 * x2 + cost3 * x3;

% Objective
solve minimize total_cost;