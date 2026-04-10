% Parameters
% Budget limit (total allocation across all projects)
int: budget = 1000;

% Constraint constants
int: c1_rhs = 200;     % for 2*x1 - 3*x2 >= 200
int: c2_offset = 300;  % for x1 <= 0.5*x3 + 300
int: c3_rhs = -500;    % for 2.5*x2 - x1 - x3 >= -500

% Costs per unit for each project
int: cost_x1 = 50;
int: cost_x2 = 60;
int: cost_x3 = 70;


% Variables
% Whole-number investments (nonnegative allocations)
var 0..budget: x1;  % allocation to project 1
var 0..budget: x2;  % allocation to project 2
var 0..budget: x3;  % allocation to project 3

% Total investment cost (integer)
var 0..(cost_x1*budget + cost_x2*budget + cost_x3*budget): total_cost;


% Constraints
% --- Budget limit: total allocation across all projects cannot exceed budget ---
constraint x1 + x2 + x3 <= budget;

% --- Linear constraint 1: 2*x1 - 3*x2 >= 200 ---
constraint 2 * x1 - 3 * x2 >= c1_rhs;

% --- Linear constraint 2: x1 <= 0.5*x3 + 300
% Avoid floats by multiplying both sides by 2: 2*x1 <= x3 + 600
constraint 2 * x1 <= x3 + 2 * c2_offset;

% --- Linear constraint 3: 2.5*x2 - x1 - x3 >= -500
% Avoid floats by multiplying both sides by 2: 5*x2 - 2*x1 - 2*x3 >= -1000
constraint 5 * x2 - 2 * x1 - 2 * x3 >= 2 * c3_rhs;

% --- Total cost definition (kept integer) ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;


% Objective
solve minimize total_cost;