% Parameters
% Cost per unit for each service (embedded from problem statement)
float: c1 = 0.5;
float: c2 = 0.2;
float: c3 = 3.0;
float: c4 = 1.5;

% Upper bounds for combined allocations
int: cap12 = 200;   % x1 + x2 <= 200
int: cap34 = 180;   % x3 + x4 <= 180

% Individual bounds (embedded from problem statement)
int: x1_lb = 50;  int: x1_ub = 150;
int: x2_lb = 80;  int: x2_ub = 120;
int: x3_lb = 20;  int: x3_ub = 70;
int: x4_lb = 30;  int: x4_ub = 60;

% Coefficients for “difference non-negative” constraints
% 0.7*x1 - x3 >= 0  and  0.5*x2 - x4 >= 0
float: alpha13 = 0.7;
float: alpha24 = 0.5;


% Variables
% Integer allocations to each service (whole numbers) with explicit bounds
var x1_lb..x1_ub: x1;  % allocation to service 1
var x2_lb..x2_ub: x2;  % allocation to service 2
var x3_lb..x3_ub: x3;  % allocation to service 3
var x4_lb..x4_ub: x4;  % allocation to service 4

% Total cost (kept as float for fractional unit costs)
var float: total_cost; % objective value (before rounding)


% Constraints
% Individual bounds are already enforced by variable domains (x1..x4)

% --- Capacity constraints on combined allocations ---
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% --- Non-negative difference / strategic emphasis constraints ---
% Use float expressions explicitly to avoid type coercion issues
constraint alpha13 * int2float(x1) - int2float(x3) >= 0.0; % 0.7*x1 - x3 >= 0
constraint alpha24 * int2float(x2) - int2float(x4) >= 0.0; % 0.5*x2 - x4 >= 0

% --- Total cost definition ---
constraint
  total_cost =
    c1 * int2float(x1) +
    c2 * int2float(x2) +
    c3 * int2float(x3) +
    c4 * int2float(x4);


% Objective
solve minimize total_cost;

% Helpful output (includes rounded-to-nearest whole number as requested)
output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n",
  "rounded_total_cost=", show(round(total_cost)), "\n"
];