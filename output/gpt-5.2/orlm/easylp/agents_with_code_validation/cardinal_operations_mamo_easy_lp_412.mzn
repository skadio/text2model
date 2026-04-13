% Parameters
% Unit costs for each project (given in the problem statement)
int: cost_x1 = 200;
int: cost_x2 = 300;
int: cost_x3 = 400;
int: cost_x4 = 500;

% Constraint limits (given in the problem statement)
int: limit_x1_x2 = 1000;     % x1 + x2 <= 1000
int: limit_2x3_x4 = 1200;    % 2*x3 + x4 <= 1200
int: min_total_alloc = 500;  % x1 + x2 + x3 + x4 >= 500

% Non-negativity lower bound (no other bounds provided in the statement)
int: lb_alloc = 0;


% Variables
% Integer allocations (indivisible resources)
var lb_alloc..max(limit_x1_x2, limit_2x3_x4): x1; % residential
var lb_alloc..max(limit_x1_x2, limit_2x3_x4): x2; % commercial
var lb_alloc..max(limit_x1_x2, limit_2x3_x4): x3; % industrial
var lb_alloc..limit_2x3_x4: x4;                   % infrastructure (bounded by 2*x3 + x4 <= 1200)

% Objective value (total cost)
var int: total_cost;


% Constraints
% Budgetary limitation: residential + commercial allocation cap
constraint x1 + x2 <= limit_x1_x2;

% Budgetary limitation: weighted industrial + infrastructure allocation cap
constraint 2 * x3 + x4 <= limit_2x3_x4;

% Minimum overall activity requirement
constraint x1 + x2 + x3 + x4 >= min_total_alloc;

% Total cost calculation
constraint total_cost =
    cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;