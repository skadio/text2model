% Parameters
% Cost factors for each route (given in the problem statement)
int: c1 = 5;
int: c2 = 10;
int: c3 = 7;
int: c4 = 8;

% Upper bounds on allocations for each route
int: ub1 = 60;
int: ub2 = 50;
int: ub3 = 150;
int: ub4 = 90;

% Cross-route capacity/requirement limits
int: cap12 = 100;   % x1 + x2 <= 100
int: cap34 = 200;   % x3 + x4 <= 200
int: req13 = 50;    % x1 + x3 >= 50
int: req24 = 80;    % x2 + x4 >= 80


% Variables
% Integer allocations on each route (whole-number resources)
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

% Total cost (bounded using max possible allocations)
var 0..(c1*ub1 + c2*ub2 + c3*ub3 + c4*ub4): total_cost;


% Constraints
% Define total cost as the weighted sum of allocations
constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Capacity constraints across paired routes
constraint x1 + x2 <= cap12;   % x1 + x2 cannot exceed 100
constraint x3 + x4 <= cap34;   % x3 + x4 cannot exceed 200

% Minimum requirement constraints across paired routes
constraint x1 + x3 >= req13;   % at least 50 units across x1 and x3
constraint x2 + x4 >= req24;   % at least 80 units across x2 and x4


% Objective
solve minimize total_cost;