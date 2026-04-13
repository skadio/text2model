% Parameters
int: BUDGET_MAX = 2000;

int: INV_MAX = 1500;
int: ADV_MAX = 800;
int: CS_MAX  = 1200;

int: COST_INV = 5;
int: COST_ADV = 3;
int: COST_CS  = 7;

int: BALANCE_MIN = 500;
int: DIFF_MAX = 1000;

% Variables
var 0..INV_MAX: x1; % inventory
var 0..ADV_MAX: x2; % advertising
var 0..CS_MAX:  x3; % customer service

var 0..(COST_INV*INV_MAX + COST_ADV*ADV_MAX + COST_CS*CS_MAX): total_cost;

% Constraints
constraint x1 + x2 + x3 <= BUDGET_MAX;

% 2*x1 - 0.5*x2 >= 500  <=>  4*x1 - x2 >= 1000
constraint 4*x1 - x2 >= 2*BALANCE_MIN;

% x3 - 0.8*x1 <= 1000  <=>  5*x3 - 4*x1 <= 5000
constraint 5*x3 - 4*x1 <= 5*DIFF_MAX;

constraint total_cost = COST_INV*x1 + COST_ADV*x2 + COST_CS*x3;

% Objective
solve minimize total_cost;