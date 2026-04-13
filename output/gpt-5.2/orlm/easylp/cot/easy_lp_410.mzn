% Parameters (with values embedded)
int: max_total_investment = 100;
int: min_diversification = 50;
int: exact_market = 75;

int: max_x1 = 40; % Residential
int: max_x2 = 50; % Commercial
int: max_x3 = 30; % Industrial
int: max_x4 = 20; % Recreational

int: c1 = 5;
int: c2 = 7;
int: c3 = 3;
int: c4 = 4;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

var 0..(c1*max_x1 + c2*max_x2 + c3*max_x3 + c4*max_x4): total_cost;

% Constraints
constraint x1 + x2 + x3 + x4 <= max_total_investment;

constraint x1 + 4*x2 + x3 + 2*x4 >= min_diversification;

constraint 3*x1 + x2 + 2*x3 + x4 = exact_market;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;