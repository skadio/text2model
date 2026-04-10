% Parameters
int: cost_x = 4;                 % Cost per unit allocated to Project X
int: cost_y = 5;                 % Cost per unit allocated to Project Y

int: max_total_weighted = 100;   % Maximum allowed: x + 3*y <= 100
int: y_weight_in_total = 3;      % Weight of Y in total limit

int: min_strategic = 50;         % Minimum strategic requirement: 2*x + y >= 50
int: x_weight_in_strategic = 2;  % Weight of X in strategic constraint

int: max_diff = 20;              % |x - y| <= 20
int: max_x = 60;                 % Upper bound on allocation to X
int: max_y = 30;                 % Upper bound on allocation to Y

% Variables
var 0..max_x: x;                 % Integer units allocated to Project X
var 0..max_y: y;                 % Integer units allocated to Project Y

% Total cost (bounded by max possible cost given max_x/max_y)
var 0..(cost_x * max_x + cost_y * max_y): total_cost;

% Constraints
% Total weighted allocation limit: x + 3*y <= 100
constraint x + y_weight_in_total * y <= max_total_weighted;

% Strategic minimum requirement: 2*x + y >= 50
constraint x_weight_in_strategic * x + y >= min_strategic;

% Balance requirement: |x - y| <= 20
constraint abs(x - y) <= max_diff;

% Define total cost from allocations
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;