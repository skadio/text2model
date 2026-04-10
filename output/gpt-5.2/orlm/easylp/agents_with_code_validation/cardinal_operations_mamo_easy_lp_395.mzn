% Parameters
% Costs per unit for each project (embedded from the problem statement)
int: cost_x1 = 10;
int: cost_x2 = 20;
int: cost_x3 = 30;
int: cost_x4 = 40;

% Constraint constants (embedded)
int: max_x1_x2 = 50;        % x1 + x2 <= 50
int: min_diff_x3_x4 = 10;   % x3 >= x4 + 10
int: max_2x1_plus_x3 = 60;  % 2*x1 + x3 <= 60
int: min_x2_over_2x4 = 5;   % x2 >= 2*x4 + 5


% Variables
% Whole-number resource units for each project (non-negative; bounded for safety)
var 0..50: x1;  % bounded by x1+x2<=50
var 0..50: x2;  % bounded by x1+x2<=50
var 0..60: x3;  % bounded by 2*x1+x3<=60 and x1>=0
var 0..50: x4;  % safe bound; implied by x3>=x4+10 and x3<=60

% Total cost (bounded using variable bounds above)
var 0..(10*50 + 20*50 + 30*60 + 40*50): total_cost;


% Constraints
% Budget/total-units coupling between projects x1 and x2
constraint x1 + x2 <= max_x1_x2;

% Priority constraint: x3 must exceed x4 by at least the required difference
constraint x3 >= x4 + min_diff_x3_x4;

% Resource limitation linking x1 and x3
constraint 2 * x1 + x3 <= max_2x1_plus_x3;

% Strategic allocation: x2 must be at least (2*x4 + offset)
constraint x2 >= 2 * x4 + min_x2_over_2x4;

% Total cost definition
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;