% Parameters
int: cost_x1 = 200;   % cost per student in course x1
int: cost_x2 = 100;   % cost per student in course x2
int: cost_x3 = 500;   % cost per student in course x3
int: cost_x4 = 300;   % cost per student in course x4

int: max_x1_x2 = 25;  % capacity constraint for x1 + x2
int: max_x3_x4 = 15;  % capacity constraint for x3 + x4
int: min_x1_x3 = 10;  % minimum enrollment for x1 + x3
int: min_x2_x4 = 20;  % minimum enrollment for x2 + x4

int: lb_x1 = 0; int: ub_x1 = 20;  % bounds for x1
int: lb_x2 = 0; int: ub_x2 = 30;  % bounds for x2
int: lb_x3 = 0; int: ub_x3 = 15;  % bounds for x3
int: lb_x4 = 0; int: ub_x4 = 20;  % bounds for x4

% Variables
var lb_x1..ub_x1: x1;  % number of students in course x1 (integer)
var lb_x2..ub_x2: x2;  % number of students in course x2 (integer)
var lb_x3..ub_x3: x3;  % number of students in course x3 (integer)
var lb_x4..ub_x4: x4;  % number of students in course x4 (integer)

% Constraints
% Capacity constraints (faculty/space limits)
constraint x1 + x2 <= max_x1_x2;
constraint x3 + x4 <= max_x3_x4;

% Minimum combined enrollment constraints (balance across disciplines)
constraint x1 + x3 >= min_x1_x3;
constraint x2 + x4 >= min_x2_x4;

% Objective
solve minimize cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;