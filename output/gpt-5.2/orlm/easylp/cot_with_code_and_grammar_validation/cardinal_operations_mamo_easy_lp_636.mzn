% Parameters
int: n = 4;
set of int: A = 1..n;

array[A] of int: cost = [300, 200, 100, 50];

% Constraints data (scaled by 2 to avoid fractions)
% 1) x1 + x2 <= 500
int: c1_rhs = 500;

% 2) 2*x1 + 3.5*x3 >= 700  => 4*x1 + 7*x3 >= 1400
int: c2_rhs_scaled2 = 1400;

% 3) x2 - 0.5*x3 - x1 <= 300  => 2*x2 - x3 - 2*x1 <= 600
int: c3_rhs_scaled2 = 600;

% 4) 0.5*x4 - x2 <= 400  => x4 - 2*x2 <= 800
int: c4_rhs_scaled2 = 800;

% 5) x4 <= x1 - 150
int: c5_offset = 150;

% Variable bounds (safe upper bounds derived from constraints)
int: ub_x1 = 500;
int: ub_x2 = 500;
int: ub_x3 = 1400; % from 7*x3 <= 1400 when x1=0 in constraint 2
int: ub_x4 = 350;  % from x4 <= x1-150 and x1<=500

% Variables
var 0..ub_x1: x1;
var 0..ub_x2: x2;
var 0..ub_x3: x3;
var 0..ub_x4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= c1_rhs;

constraint 4*x1 + 7*x3 >= c2_rhs_scaled2;

constraint 2*x2 - x3 - 2*x1 <= c3_rhs_scaled2;

constraint x4 - 2*x2 <= c4_rhs_scaled2;

constraint x4 <= x1 - c5_offset;

constraint total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;

% Objective
solve minimize total_cost;