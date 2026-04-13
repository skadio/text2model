% Parameters
% Costs per visitor at each spot (given directly in the problem statement)
int: c1 = 50;
int: c2 = 100;
int: c3 = 200;
int: c4 = 300;

% Capacity / bound limits for visitor numbers at each spot
int: x1_min = 0;   int: x1_max = 500;
int: x2_min = 0;   int: x2_max = 400;
int: x3_min = 0;   int: x3_max = 600;
int: x4_min = 0;   int: x4_max = 700;

% Constraint constants (given directly in the problem statement)
int: max_x1_x2 = 500;      % x1 + x2 <= 500
int: min_x2_x3 = 300;      % x2 + x3 >= 300
int: max_diff_x3_x4 = 100; % |x3 - x4| <= 100
int: min_diff_x4_x1 = 50;  % x4 - x1 >= 50

% Variables
var x1_min..x1_max: x1; % visitors allocated to spot 1
var x2_min..x2_max: x2; % visitors allocated to spot 2
var x3_min..x3_max: x3; % visitors allocated to spot 3
var x4_min..x4_max: x4; % visitors allocated to spot 4

var int: total_cost; % total cost in dollars (integer)

% Constraints
% --- Total cost definition ---
% Total cost is the weighted sum of visitors at each spot by their per-visitor costs.
constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

% --- Budget/combined-visitor constraints ---
% The combined number of visitors for spots x1 and x2 cannot exceed the limit.
constraint x1 + x2 <= max_x1_x2;

% The combined number of visitors for spots x2 and x3 must be at least the minimum required.
constraint x2 + x3 >= min_x2_x3;

% --- Difference constraints between allocations ---
% The difference in visitors between x3 and x4 must not exceed the maximum allowed.
constraint abs(x3 - x4) <= max_diff_x3_x4;

% The difference between x4 and x1 must be at least the minimum required (x4 at least x1 + 50).
constraint x4 - x1 >= min_diff_x4_x1;

% Objective
solve minimize total_cost;