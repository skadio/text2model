% Parameters
% Resource consumption per unit of each product
int: a_x1 = 5;   % resource A used by product x1
int: b_x1 = 4;   % resource B used by product x1
int: a_x2 = 3;   % resource A used by product x2
int: b_x2 = 6;   % resource B used by product x2
int: a_x3 = 8;   % resource A used by product x3
int: b_x3 = 7;   % resource B used by product x3

% Resource availability
int: A_avail = 1000; % total available units of resource A
int: B_avail = 800;  % total available units of resource B

% Demand constraint threshold
int: demand_min = 100; % minimum required for x1 - 2*x2 + x3

% Unit costs
int: cost_x1 = 10; % cost per unit of x1
int: cost_x2 = 15; % cost per unit of x2
int: cost_x3 = 20; % cost per unit of x3

% Maximum production limits
int: x1_max = 300;
int: x2_max = 200;
int: x3_max = 150;

% Variables
var 0..x1_max: x1; % units of product x1 to produce (integer, bounded)
var 0..x2_max: x2; % units of product x2 to produce (integer, bounded)
var 0..x3_max: x3; % units of product x3 to produce (integer, bounded)

% Upper bound on total cost from variable bounds
int: total_cost_ub = cost_x1*x1_max + cost_x2*x2_max + cost_x3*x3_max;
var 0..total_cost_ub: total_cost; % total cost (bounded integer)

% Constraints
% Resource A capacity constraint
constraint
  a_x1 * x1 + a_x2 * x2 + a_x3 * x3 <= A_avail;

% Resource B capacity constraint
constraint
  b_x1 * x1 + b_x2 * x2 + b_x3 * x3 <= B_avail;

% Demand satisfaction constraint: x1 - 2*x2 + x3 must meet minimum threshold
constraint
  x1 - 2 * x2 + x3 >= demand_min;

% Total cost definition constraint
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Objective
solve minimize total_cost;