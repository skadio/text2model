% Parameters
int: budget = 1000;                 % Maximum total resource allocation
int: min_quality = 200;             % Minimum required value for (2*X - Y)
int: max_balance_diff = 50;         % Maximum allowed absolute difference |Y - Z|

int: costX = 10;                    % Cost per unit on route X
int: costY = 20;                    % Cost per unit on route Y
int: costZ = 30;                    % Cost per unit on route Z

int: lbX = 0; int: ubX = budget;    % Bounds for allocation on route X
int: lbY = 0; int: ubY = budget;    % Bounds for allocation on route Y
int: lbZ = 0; int: ubZ = budget;    % Bounds for allocation on route Z

% Variables
var lbX..ubX: x;                    % Whole-number resource allocation to route X
var lbY..ubY: y;                    % Whole-number resource allocation to route Y
var lbZ..ubZ: z;                    % Whole-number resource allocation to route Z

var 0..(costX*budget + costY*budget + costZ*budget): totalCost;  % Total cost in dollars

% Constraints

% Budget constraint: total allocation across all routes cannot exceed budget
constraint
  x + y + z <= budget;

% Service quality constraint: twice X minus Y must be at least the required minimum
constraint
  2 * x - y >= min_quality;

% Balance constraint: difference between Y and Z must be within the allowed bound
constraint
  abs(y - z) <= max_balance_diff;

% Total cost definition: compute totalCost from allocations and per-unit costs
constraint
  totalCost = costX * x + costY * y + costZ * z;

% Objective
solve minimize totalCost;