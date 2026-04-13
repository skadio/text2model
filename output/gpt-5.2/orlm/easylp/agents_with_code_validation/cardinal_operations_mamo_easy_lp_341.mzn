% Parameters
% Cost coefficients for each route (embedded from problem statement)
int: c1 = 5;
int: c2 = 10;
int: c3 = 7;
int: c4 = 8;

% Upper bounds for each route allocation (embedded)
int: ub1 = 60;
int: ub2 = 50;
int: ub3 = 150;
int: ub4 = 90;

% Coupling constraints limits (embedded)
int: cap12 = 100;   % x1 + x2 <= 100
int: cap34 = 200;   % x3 + x4 <= 200
int: dem13 = 50;    % x1 + x3 >= 50
int: dem24 = 80;    % x2 + x4 >= 80

% Variables
var 0..ub1: x1;  % units allocated to route 1
var 0..ub2: x2;  % units allocated to route 2
var 0..ub3: x3;  % units allocated to route 3
var 0..ub4: x4;  % units allocated to route 4

var int: total_cost; % total cost = 5*x1 + 10*x2 + 7*x3 + 8*x4

% Constraints
% Define total cost from route allocations and per-unit cost coefficients
constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Capacity limits on coupled routes
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% Minimum demand / strategic allocation requirements on coupled routes
constraint x1 + x3 >= dem13;
constraint x2 + x4 >= dem24;

% Objective
solve minimize total_cost;

% Optional output for inspection
output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];