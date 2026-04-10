% Parameters (with values embedded)
int: cost_X1 = 4;
int: cost_X2 = 5;
int: cost_X3 = 6;

int: limit1 = 1000;   % X1 + 2*X2 <= 1000
int: limit2 = 600;    % X2 + 3*X3 >= 600
int: balance = 500;   % 2*X3 - X1 = 500

% Variable bounds derived from constraints:
% From 2*X3 - X1 = 500 and X1 >= 0 => X3 >= 250
% From X1 + 2*X2 <= 1000 and X2 >= 0 => X1 <= 1000
% Then 2*X3 = X1 + 500 <= 1500 => X3 <= 750
int: X1_lb = 0;
int: X1_ub = 1000;
int: X3_lb = 250;
int: X3_ub = 750;

% Variables
var X1_lb..X1_ub: X1;
var 0..1000: X2;
var X3_lb..X3_ub: X3;

var 0..10000000: total_cost;

% Constraints
constraint X1 + 2*X2 <= limit1;
constraint X2 + 3*X3 >= limit2;
constraint 2*X3 - X1 = balance;

constraint total_cost = cost_X1*X1 + cost_X2*X2 + cost_X3*X3;

% Objective
solve minimize total_cost;