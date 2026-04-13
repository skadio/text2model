% Parameters
% Cost coefficients (per unit allocated)
int: cost_x1 = 5000;
int: cost_x2 = 3000;
int: cost_x3 = 4000;
int: cost_x4 = 2000;

% Total allocation limit
int: total_cap = 10000;

% Individual allocation bounds
int: x1_lb = 0;    int: x1_ub = 3000;
int: x2_lb = 0;    int: x2_ub = 2500;
int: x3_lb = 0;    int: x3_ub = 1500;
int: x4_lb = 0;    int: x4_ub = 300;

% Scale factor to model fractional coefficients as integers (LCM of 2 and 10)
int: scale = 10;

% Scaled coefficients/constants for constraints
% 5*x1 >= 2000 + 3.5*x2  =>  50*x1 >= 20000 + 35*x2
int: c1_a_x1 = 50;
int: c1_a_x2 = 35;
int: c1_rhs  = 20000;

% 4.7*x4 <= x3 + 3500  =>  47*x4 <= 10*x3 + 35000
int: c2_a_x4 = 47;
int: c2_a_x3 = 10;
int: c2_rhs  = 35000;

% x2 + 3.5*x3 + x4 - 2.5*x1 >= 1000  =>  10*x2 + 35*x3 + 10*x4 - 25*x1 >= 10000
int: c3_a_x2 = 10;
int: c3_a_x3 = 35;
int: c3_a_x4 = 10;
int: c3_a_x1 = 25;
int: c3_rhs  = 10000;


% Variables
% Integer allocations to each unit (whole-number resources)
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

% Total cost (integer dollars/units)
var 0..(cost_x1*x1_ub + cost_x2*x2_ub + cost_x3*x3_ub + cost_x4*x4_ub): total_cost;


% Constraints

%----------------------------
% Total allocation capacity
%----------------------------
constraint
  x1 + x2 + x3 + x4 <= total_cap;

%---------------------------------------------
% Operational requirement 1 (scaled to int)
% 5*x1 >= 2000 + 3.5*x2  =>  50*x1 >= 20000 + 35*x2
%---------------------------------------------
constraint
  c1_a_x1 * x1 >= c1_rhs + c1_a_x2 * x2;

%---------------------------------------------
% Operational requirement 2 (scaled to int)
% 4.7*x4 <= x3 + 3500  =>  47*x4 <= 10*x3 + 35000
%---------------------------------------------
constraint
  c2_a_x4 * x4 <= c2_a_x3 * x3 + c2_rhs;

%------------------------------------------------------------
% Operational requirement 3 (scaled to int)
% x2 + 3.5*x3 + x4 - 2.5*x1 >= 1000
% => 10*x2 + 35*x3 + 10*x4 - 25*x1 >= 10000
%------------------------------------------------------------
constraint
  c3_a_x2 * x2 + c3_a_x3 * x3 + c3_a_x4 * x4 - c3_a_x1 * x1 >= c3_rhs;

%----------------------------
% Total cost definition
%----------------------------
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;