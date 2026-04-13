% Parameters
% Total available resource units (given in problem statement)
int: total_resource_limit = 1000;

% Minimum difference constraints (given in problem statement)
int: min_res_over_com = 50;      % X >= Y + 50
int: max_ind_res_diff = 200;     % |Z - X| <= 200
int: min_com_over_ind = 30;      % Y >= Z + 30

% Per-unit costs (given in problem statement)
int: cost_residential = 200;     % cost per unit of X
int: cost_commercial  = 150;     % cost per unit of Y
int: cost_industrial  = 300;     % cost per unit of Z

% Variables
var 0..total_resource_limit: X;  % residential resource allocation (integer units)
var 0..total_resource_limit: Y;  % commercial resource allocation (integer units)
var 0..total_resource_limit: Z;  % industrial resource allocation (integer units)

% Upper bound is a safe over-approximation of worst-case spending within the resource limit.
var 0..(cost_residential*total_resource_limit
      + cost_commercial*total_resource_limit
      + cost_industrial*total_resource_limit): total_cost; % total cost (integer dollars)

% Constraints
% Resource budget constraint: total allocated units cannot exceed the limit
constraint X + Y + Z <= total_resource_limit;

% Strategic allocation constraints:
% 1) Residential must exceed Commercial by at least min_res_over_com
constraint X >= Y + min_res_over_com;

% 2) Commercial must exceed Industrial by at least min_com_over_ind
constraint Y >= Z + min_com_over_ind;

% 3) Industrial and Residential allocations must be within max_ind_res_diff (absolute difference)
constraint abs(Z - X) <= max_ind_res_diff;

% Total cost definition constraint (link total_cost to decision variables and per-unit costs)
constraint
  total_cost = cost_residential * X
             + cost_commercial  * Y
             + cost_industrial  * Z;

% Objective
solve minimize total_cost;