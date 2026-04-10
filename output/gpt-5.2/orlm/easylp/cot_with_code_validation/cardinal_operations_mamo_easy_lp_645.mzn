% Parameters
int: max_x1 = 150;
int: max_x2 = 100;
int: max_x3 = 80;
int: max_x4 = 20;

int: cost_x1 = 10000;
int: cost_x2 = 5000;
int: cost_x3 = 8000;
int: cost_x4 = 6000;

int: max_x1_x2_sum = 200;

% Strength constraint: 2*x1 + 3.5*x3 >= 400  ->  4*x1 + 7*x3 >= 800
int: strength_rhs = 800;

% |x2 - 0.5*x4| <= 50  ->  |2*x2 - x4| <= 100
int: diff_bound = 100;

% x2 - x1 - x3 <= 70
int: balance_bound = 70;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3 + cost_x4*max_x4): total_support;

% Constraints
constraint x1 + x2 <= max_x1_x2_sum;

constraint 4*x1 + 7*x3 >= strength_rhs;

constraint abs(2*x2 - x4) <= diff_bound;

constraint x2 - x1 - x3 <= balance_bound;

constraint total_support = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

% Objective
solve minimize total_support;