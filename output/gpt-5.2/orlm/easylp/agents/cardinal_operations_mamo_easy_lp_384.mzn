% Parameters
% Cost per hour for each training area
int: cost_x1 = 20;  % strength & conditioning
int: cost_x2 = 30;  % skill development
int: cost_x3 = 50;  % strategy learning
int: cost_x4 = 60;  % recovery sessions

% Bounds for each activity (hours)
int: x1_lb = 0;  int: x1_ub = 15;
int: x2_lb = 0;  int: x2_ub = 12;
int: x3_lb = 0;  int: x3_ub = 10;
int: x4_lb = 0;  int: x4_ub = 8;

% Constraint constants
int: min_x1_x2 = 5;         % x1 + x2 >= 5
int: max_diff_x3_x4 = 10;   % |x3 - x4| <= 10
int: min_lin_expr = 8;      % 2*x1 + 3*x2 - x4 >= 8
int: max_diff_x1_x3 = 6;    % |x1 - x3| <= 6


% Variables
var x1_lb..x1_ub: x1;  % hours for strength & conditioning (integer)
var x2_lb..x2_ub: x2;  % hours for skill development (integer)
var x3_lb..x3_ub: x3;  % hours for strategy learning (integer)
var x4_lb..x4_ub: x4;  % hours for recovery sessions (integer)

% Total cost (integer dollars)
var 0..(cost_x1*x1_ub + cost_x2*x2_ub + cost_x3*x3_ub + cost_x4*x4_ub): total_cost;


% Constraints
% Total cost definition (linear accumulation of costs)
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Minimum combined hours for strength & conditioning and skill development
constraint
  x1 + x2 >= min_x1_x2;

% Balance between strategy learning and recovery: absolute difference bounded
constraint
  abs(x3 - x4) <= max_diff_x3_x4;

% Minimum weighted training requirement: 2*x1 + 3*x2 - x4 >= 8
constraint
  2 * x1 + 3 * x2 - x4 >= min_lin_expr;

% Physical foundation vs strategy learning balance: absolute difference bounded
constraint
  abs(x1 - x3) <= max_diff_x1_x3;


% Objective
solve minimize total_cost;