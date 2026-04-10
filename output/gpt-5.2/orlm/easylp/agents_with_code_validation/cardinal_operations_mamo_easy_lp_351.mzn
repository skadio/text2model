% Parameters
% Cost coefficients for each department allocation variable
int: c1 = 100;   % cost per unit for x1 (general medicine)
int: c2 = 50;    % cost per unit for x2 (surgery)
int: c3 = 30;    % cost per unit for x3 (diagnostics)
int: c4 = 200;   % cost per unit for x4 (research)

% Minimum combined allocation requirements
int: min_x1_x2 = 10;   % x1 + x2 >= 10
int: min_x3_x4 = 20;   % x3 + x4 >= 20

% Linear constraint coefficients
% 5*x1 - 2*x2 <= 0
int: a12_1 = 5;
int: a12_2 = -2;
int: rhs_12 = 0;

% 3*x3 - x4 >= 0
int: a34_3 = 3;
int: a34_4 = -1;
int: rhs_34 = 0;

% Bounds on allocations (nonnegative integer allocations)
int: lb_x1 = 0;
int: lb_x2 = 0;
int: lb_x3 = 0;
int: lb_x4 = 0;

% Safe finite upper bounds to keep variables bounded
int: ub_x1 = 1000;
int: ub_x2 = 1000;
int: ub_x3 = 1000;
int: ub_x4 = 1000;

% Variables
var lb_x1..ub_x1: x1;  % allocation to general medicine (integer)
var lb_x2..ub_x2: x2;  % allocation to surgery (integer)
var lb_x3..ub_x3: x3;  % allocation to diagnostics (integer)
var lb_x4..ub_x4: x4;  % allocation to research (integer)

% Total cost (objective variable)
var 0..(c1*ub_x1 + c2*ub_x2 + c3*ub_x3 + c4*ub_x4): total_cost;

% Constraints
% --- Minimum combined allocation requirements ---
constraint x1 + x2 >= min_x1_x2;   % General medicine + surgery minimum
constraint x3 + x4 >= min_x3_x4;   % Diagnostics + research minimum

% --- Linear balance/priority constraints ---
constraint a12_1 * x1 + a12_2 * x2 <= rhs_12;   % 5*x1 - 2*x2 <= 0 funding balance
constraint a34_3 * x3 + a34_4 * x4 >= rhs_34;   % 3*x3 - x4 >= 0 diagnostics priority

% --- Total cost definition (links objective variable to decision variables) ---
constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;