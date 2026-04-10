% Parameters
% Promotion cost per unit allocation for each destination (embedded from description)
int: cost_x1 = 200;
int: cost_x2 = 150;
int: cost_x3 = 100;
int: cost_x4 = 50;

% Upper bounds on combined allocations (embedded from description)
int: max_x1_x2 = 300;   % x1 + x2 <= 300
int: max_x3_x4 = 200;   % x3 + x4 <= 200

% Lower bounds on combined allocations (embedded from description)
int: min_x1_x3 = 150;   % x1 + x3 >= 150
int: min_x2_x4 = 150;   % x2 + x4 >= 150


% Variables
% Integer resource allocations to each destination (non-negative, bounded by group maxima)
var 0..max_x1_x2: x1;   % since x1 <= x1+x2 <= 300
var 0..max_x1_x2: x2;   % since x2 <= x1+x2 <= 300
var 0..max_x3_x4: x3;   % since x3 <= x3+x4 <= 200
var 0..max_x3_x4: x4;   % since x4 <= x3+x4 <= 200

% Total cost (bounded using the above variable bounds)
int: total_cost_ub =
  cost_x1*max_x1_x2 + cost_x2*max_x1_x2 + cost_x3*max_x3_x4 + cost_x4*max_x3_x4;
var 0..total_cost_ub: total_cost;  % objective value


% Constraints
% --- Budget / group upper-bound constraints ---
constraint x1 + x2 <= max_x1_x2;  % Combined allocation to x1 and x2 capped
constraint x3 + x4 <= max_x3_x4;  % Combined allocation to x3 and x4 capped

% --- Strategic / minimum coverage constraints ---
constraint x1 + x3 >= min_x1_x3;  % Ensure minimum combined promotion for x1 and x3
constraint x2 + x4 >= min_x2_x4;  % Ensure minimum combined promotion for x2 and x4

% --- Total cost definition ---
constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;


% Objective
solve minimize total_cost;