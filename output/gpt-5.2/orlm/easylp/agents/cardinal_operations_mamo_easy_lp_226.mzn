% Parameters
int: cost_x1 = 3;                % Cost per unit allocated to Project X1
int: cost_x2 = 2;                % Cost per unit allocated to Project X2
int: cost_x3 = 5;                % Cost per unit allocated to Project X3

int: total_alloc_max = 1000;     % Upper bound on x1 + x2 + x3
int: min_expr_bound = 500;       % Lower bound on 2*x1 - 3*x3
int: expr2_max = 1200;           % Upper bound on 4*x2 + x3

int: x1_max = 400;               % Maximum allocation for Project X1
int: x2_max = 300;               % Maximum allocation for Project X2
int: x3_max = 600;               % Maximum allocation for Project X3

% Variables
var 0..x1_max: x1;               % Integer allocation to Project X1
var 0..x2_max: x2;               % Integer allocation to Project X2
var 0..x3_max: x3;               % Integer allocation to Project X3

var int: total_cost;             % Total cost = 3*x1 + 2*x2 + 5*x3

% Constraints
% Total cost definition (linking variable)
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Budgetary limitation: combined allocation cap
constraint x1 + x2 + x3 <= total_alloc_max;

% Priority/complexity requirement: 2*x1 - 3*x3 must meet minimum bound
constraint 2 * x1 - 3 * x3 >= min_expr_bound;

% Additional limitation: 4*x2 + x3 must not exceed its maximum bound
constraint 4 * x2 + x3 <= expr2_max;

% Objective
solve minimize total_cost;