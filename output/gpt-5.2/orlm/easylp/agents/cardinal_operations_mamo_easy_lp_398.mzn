% Parameters
% Unit costs ($ per unit) for each project
int: cost_x1 = 10;
int: cost_x2 = 20;
int: cost_x3 = 30;
int: cost_x4 = 40;

% Constraint right-hand-sides
int: max_x1_x2 = 100;      % x1 + x2 <= 100
int: min_x3_x4 = 50;       % x3 + x4 >= 50

% Upper bounds on allocations (safe broad bounds)
int: ub_x1 = 1000;
int: ub_x2 = 1000;
int: ub_x3 = 1000;
int: ub_x4 = 1000;

% Variables
var 0..ub_x1: x1; % allocation to project 1 (integer units)
var 0..ub_x2: x2; % allocation to project 2 (integer units)
var 0..ub_x3: x3; % allocation to project 3 (integer units)
var 0..ub_x4: x4; % allocation to project 4 (integer units)

% Total cost (integer dollars)
var int: total_cost;

% Constraints
%---------------------------
% Budget / capacity limits
%---------------------------
constraint x1 + x2 <= max_x1_x2;     % Combined allocation to projects 1 and 2 is capped
constraint x3 + x4 >= min_x3_x4;     % Combined allocation to projects 3 and 4 must meet minimum

%---------------------------
% Cross-project coupling constraints
%---------------------------
constraint 2*x1 + 3*x2 - x3 <= 0;    % Linear relationship limiting x1/x2 relative to x3
constraint 4*x3 - 2*x2 = 5*x4;       % Balance equation among x2, x3, and x4

%---------------------------
% Total cost definition
%---------------------------
constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

% Objective
solve minimize total_cost;