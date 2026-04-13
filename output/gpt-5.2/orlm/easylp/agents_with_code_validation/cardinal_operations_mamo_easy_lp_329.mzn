% Parameters
% Cost coefficients for activities x1..x4
array[1..4] of int: cost = [2, 3, 5, 4];

% Constraint right-hand sides
int: rhs_x1_x2_max = 100;     % x1 + x2 <= 100
int: rhs_2x1_x3_min = 150;    % 2*x1 + x3 >= 150
int: rhs_x2_3x4_max = 50;     % x2 - 3*x4 <= 50
int: rhs_x3_x4_min = 20;      % x3 - x4 >= 20


% Variables
% Integer budget allocations (whole numbers)
var 0..1000: x1;  % allocation to activity 1 (digital)
var 0..1000: x2;  % allocation to activity 2 (traditional)
var 0..1000: x3;  % allocation to activity 3 (influencer)
var 0..1000: x4;  % allocation to activity 4 (events)

% Total cost to minimize (upper bound from variable domains)
var 0..(2*1000 + 3*1000 + 5*1000 + 4*1000): total_cost;


% Constraints
% Link total cost to allocations
constraint
  total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;

% Strategic / budget constraints
constraint
  x1 + x2 <= rhs_x1_x2_max;

constraint
  2*x1 + x3 >= rhs_2x1_x3_min;

constraint
  x2 - 3*x4 <= rhs_x2_3x4_max;

constraint
  x3 - x4 >= rhs_x3_x4_min;


% Objective
solve minimize total_cost;

% (Optional) Output for inspection
output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4),
  " total_cost=", show(total_cost)
];