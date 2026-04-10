% Parameters
% Costs per visitor for each tourism spot (embedded data)
int: cost_x1 = 50;
int: cost_x2 = 100;
int: cost_x3 = 200;
int: cost_x4 = 300;

% Capacity (lower/upper) bounds for number of visitors at each spot (embedded data)
int: x1_lb = 0;   int: x1_ub = 500;
int: x2_lb = 0;   int: x2_ub = 400;
int: x3_lb = 0;   int: x3_ub = 600;
int: x4_lb = 0;   int: x4_ub = 700;

% Constraint limits (embedded data)
int: max_x1_x2 = 500;      % x1 + x2 <= 500
int: min_x2_x3 = 300;      % x2 + x3 >= 300
int: max_diff_x3_x4 = 100; % |x3 - x4| <= 100
int: min_diff_x4_x1 = 50;  % x4 - x1 >= 50

% Variables
% Decision variables: number of visitors allocated to each spot (integers)
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

% Total cost (upper bound from max visitors at each spot)
var 0..(cost_x1*x1_ub + cost_x2*x2_ub + cost_x3*x3_ub + cost_x4*x4_ub): total_cost;

% Constraints
% Total cost definition (link total_cost to decision variables)
constraint total_cost =
  cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Budget/combined visitor constraints
constraint x1 + x2 <= max_x1_x2;   % x1 + x2 cannot exceed 500
constraint x2 + x3 >= min_x2_x3;   % x2 + x3 must be at least 300

% Difference constraints between visitor counts
constraint abs(x3 - x4) <= max_diff_x3_x4;  % |x3 - x4| must not exceed 100
constraint x4 - x1 >= min_diff_x4_x1;       % x4 must exceed x1 by at least 50

% Objective
solve minimize total_cost;