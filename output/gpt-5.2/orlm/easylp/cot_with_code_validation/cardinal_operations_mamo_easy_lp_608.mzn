% Parameters
int: cost_x1 = 50;
int: cost_x2 = 30;
int: cost_x3 = 70;
int: cost_x4 = 60;

int: max_x1 = 1000;
int: max_x2 = 1200;
int: max_x3 = 800;
int: max_x4 = 700;

int: cap_x1_x2 = 2000;
int: cap_x3_x4 = 1500;

int: diff_x1_x2 = 500; % 1/2 x1 >= 1/3 x2 + 500  => 3*x1 - 2*x2 >= 3000
int: diff_x4_x3 = 100; % x4 >= x3 + 100

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= cap_x1_x2;
constraint x3 + x4 <= cap_x3_x4;

constraint 3 * x1 - 2 * x2 >= 6 * diff_x1_x2; % 3*x1 - 2*x2 >= 3000
constraint x4 - x3 >= diff_x4_x3;

constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;