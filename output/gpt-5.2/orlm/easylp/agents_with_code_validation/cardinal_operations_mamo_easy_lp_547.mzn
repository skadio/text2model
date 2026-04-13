% Parameters
% Cost coefficients
int: cost_mfg = 2;
int: cost_dist = 3;
int: cost_retail = 4;

% Global budget / capacity
int: max_total_alloc = 1000;

% Constraint thresholds (scaled to avoid fractions)
% 5*x1 - 0.5*x2 >= 500  ==>  10*x1 - x2 >= 1000
int: c2_rhs = 1000;

% 4.5*x3 - x1 <= 450  ==>  9*x3 - 2*x1 <= 900
int: c3_rhs = 900;

% x2 + 0.5*x3 - x1 >= 200  ==>  2*x2 + x3 - 2*x1 >= 400
int: c4_rhs = 400;

% Upper bounds (integer allocations)
int: ub_mfg = 599;      % "less than 600"
int: ub_dist = 500;     % "at most 500"
int: ub_retail = 299;   % "less than 300"

% Variables
var 0..ub_mfg: x1;      % manufacturing allocation
var 0..ub_dist: x2;     % distribution allocation
var 0..ub_retail: x3;   % retail allocation

var int: total_cost;    % total operational cost (objective)

% Constraints
%----------------------------
% Total allocation / capacity
%----------------------------
constraint
  x1 + x2 + x3 <= max_total_alloc;

%--------------------------------------------
% Operational requirement: production vs. dist
% 5*x1 - 0.5*x2 >= 500  ==>  10*x1 - x2 >= 1000
%--------------------------------------------
constraint
  10 * x1 - x2 >= c2_rhs;

%---------------------------------------------------
% Balance requirement: retail vs. manufacturing
% 4.5*x3 - x1 <= 450  ==>  9*x3 - 2*x1 <= 900
%---------------------------------------------------
constraint
  9 * x3 - 2 * x1 <= c3_rhs;

%---------------------------------------------------------
% Logistics / strategy requirement
% x2 + 0.5*x3 - x1 >= 200  ==>  2*x2 + x3 - 2*x1 >= 400
%---------------------------------------------------------
constraint
  2 * x2 + x3 - 2 * x1 >= c4_rhs;

%----------------------------
% Total cost linking equation
%----------------------------
constraint
  total_cost = cost_mfg * x1 + cost_dist * x2 + cost_retail * x3;

% Objective
solve minimize total_cost;

output [
  "x1 (mfg) = ", show(x1), "\n",
  "x2 (dist) = ", show(x2), "\n",
  "x3 (retail) = ", show(x3), "\n",
  "total_cost = ", show(total_cost), "\n"
];