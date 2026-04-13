% Parameters
int: BUDGET = 2000;

int: max_x1 = 1500;
int: max_x2 = 800;
int: max_x3 = 1200;

int: c1 = 5;
int: c2 = 3;
int: c3 = 7;

int: min_balance = 500;     % 2*x1 - 0.5*x2 >= 500  ->  4*x1 - x2 >= 1000
int: max_diff = 1000;       % x3 - 0.8*x1 <= 1000   ->  5*x3 - 4*x1 <= 5000

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;

var 0..(c1*max_x1 + c2*max_x2 + c3*max_x3): total_cost;

% Constraints
constraint x1 + x2 + x3 <= BUDGET;

% Convert fractional coefficients to integer form
constraint 4*x1 - x2 >= 2*min_balance;        % 4*x1 - x2 >= 1000
constraint 5*x3 - 4*x1 <= 5*max_diff;         % 5*x3 - 4*x1 <= 5000

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;