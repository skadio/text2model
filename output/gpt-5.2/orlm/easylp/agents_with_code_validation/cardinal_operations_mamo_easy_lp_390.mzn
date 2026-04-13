% Parameters
% Per-student costs for each course
int: cost_x1 = 200;
int: cost_x2 = 100;
int: cost_x3 = 500;
int: cost_x4 = 300;

% Capacity / availability constraints
int: max_x1_x2 = 25;   % x1 + x2 <= 25
int: max_x3_x4 = 15;   % x3 + x4 <= 15

% Minimum combined enrollment requirements
int: min_x1_x3 = 10;   % x1 + x3 >= 10
int: min_x2_x4 = 20;   % x2 + x4 >= 20

% Enrollment bounds (class size restrictions)
int: x1_lb = 0;  int: x1_ub = 20;
int: x2_lb = 0;  int: x2_ub = 30;
int: x3_lb = 0;  int: x3_ub = 15;
int: x4_lb = 0;  int: x4_ub = 20;

% Variables
var x1_lb..x1_ub: x1;  % number of students in course x1
var x2_lb..x2_ub: x2;  % number of students in course x2
var x3_lb..x3_ub: x3;  % number of students in course x3
var x4_lb..x4_ub: x4;  % number of students in course x4

% Total cost variable (upper bound computed from max possible enrollments)
var 0..(cost_x1*x1_ub + cost_x2*x2_ub + cost_x3*x3_ub + cost_x4*x4_ub): total_cost;


% Constraints

% --- Capacity / availability constraints ---
constraint x1 + x2 <= max_x1_x2;  % combined enrollment in courses x1 and x2 is limited
constraint x3 + x4 <= max_x3_x4;  % combined enrollment in courses x3 and x4 is limited

% --- Minimum combined enrollment (balance) constraints ---
constraint x1 + x3 >= min_x1_x3;  % ensure enough students across courses x1 and x3
constraint x2 + x4 >= min_x2_x4;  % ensure enough students across courses x2 and x4

% --- Total cost definition constraint ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;