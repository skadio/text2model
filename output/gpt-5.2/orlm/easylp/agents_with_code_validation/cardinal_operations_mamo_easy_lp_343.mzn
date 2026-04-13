% Parameters
% Operational costs per route (embedded from problem statement)
int: cost_x1 = 5;
int: cost_x2 = 4;
int: cost_x3 = 6;
int: cost_x4 = 7;

% Capacity bounds per route (embedded from problem statement)
int: lb_x1 = 0;  int: ub_x1 = 50;
int: lb_x2 = 0;  int: ub_x2 = 40;
int: lb_x3 = 0;  int: ub_x3 = 60;
int: lb_x4 = 0;  int: ub_x4 = 70;

% Constraint RHS values (embedded from problem statement)
int: max_x1_x2 = 20;
int: max_x3_x4 = 30;
int: min_x1_x3 = 15;
int: min_x2_x4 = 10;


% Variables
% Number of vehicles assigned to each route (integer, bounded)
var lb_x1..ub_x1: x1;
var lb_x2..ub_x2: x2;
var lb_x3..ub_x3: x3;
var lb_x4..ub_x4: x4;

% Total operational cost (bounded using min/max possible costs)
int: min_cost =
  cost_x1*lb_x1 + cost_x2*lb_x2 + cost_x3*lb_x3 + cost_x4*lb_x4;
int: max_cost =
  cost_x1*ub_x1 + cost_x2*ub_x2 + cost_x3*ub_x3 + cost_x4*ub_x4;
var min_cost..max_cost: total_cost;


% Constraints
% Compute total operational cost from route allocations
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Traffic regulation / joint capacity limits
constraint
  x1 + x2 <= max_x1_x2;

constraint
  x3 + x4 <= max_x3_x4;

% Minimum service coverage requirements
constraint
  x1 + x3 >= min_x1_x3;

constraint
  x2 + x4 >= min_x2_x4;


% Objective
solve minimize total_cost;