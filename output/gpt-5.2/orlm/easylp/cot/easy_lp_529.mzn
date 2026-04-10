% Parameters (with values embedded)
int: BUDGET = 2000;

int: max_x1 = 1500; % inventory
int: max_x2 = 800;  % advertising
int: max_x3 = 1200; % customer service

int: cost1 = 5;
int: cost2 = 3;
int: cost3 = 7;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;

var 0..(cost1*max_x1 + cost2*max_x2 + cost3*max_x3): total_cost;

% Constraints
constraint x1 + x2 + x3 <= BUDGET;

% 2*x1 - 0.5*x2 >= 500  <=>  4*x1 - x2 >= 1000
constraint 4*x1 - x2 >= 1000;

% x3 - 0.8*x1 <= 1000  <=>  5*x3 - 4*x1 <= 5000
constraint 5*x3 - 4*x1 <= 5000;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3;

% Objective
solve minimize total_cost;