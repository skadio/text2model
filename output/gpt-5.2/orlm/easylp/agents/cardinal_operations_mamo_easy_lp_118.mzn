% Parameters
% Resource usage coefficients and limits
int: aX = 2;                 % coefficient for package X in main resource constraint
int: aY = 3;                 % coefficient for package Y in main resource constraint
int: max_resource = 50;      % upper bound on weighted resources

int: min_combined = 10;      % minimum combined resources X + Y
int: max_diff = 20;          % maximum allowed absolute difference |X - Y|

% Costs per unit resource
int: costX = 100;            % cost per unit for package X
int: costY = 200;            % cost per unit for package Y

% Variables
var 0..max_resource: x;      % integer units allocated to package X
var 0..max_resource: y;      % integer units allocated to package Y

% Total cost in dollars (safe upper bound)
var 0..(costX*max_resource + costY*max_resource): total_cost;

% Constraints
% Weighted main resource capacity: 2*x + 3*y <= 50
constraint
  aX * x + aY * y <= max_resource;

% Minimum combined allocation: x + y >= 10
constraint
  x + y >= min_combined;

% Logistical constraint on difference: |x - y| <= 20
constraint
  abs(x - y) <= max_diff;

% Define total cost from allocations
constraint
  total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;