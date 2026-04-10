% Parameters
int: cost_x = 4;                 % Cost per unit resource allocated to Project X
int: cost_y = 5;                 % Cost per unit resource allocated to Project Y

int: max_combined = 100;         % Upper bound for x + 2*y
int: min_requirement = 50;       % Lower bound for 3*x - y


% Variables
var 0..max_combined: x;          % Integer units allocated to Project X (non-negative)
var 0..max_combined: y;          % Integer units allocated to Project Y (non-negative)

var int: total_cost;             % Total cost = cost_x*x + cost_y*y


% Constraints
% Total cost definition (linking variable)
constraint total_cost = cost_x * x + cost_y * y;

% Budget/combined allocation limit: x + 2*y <= 100
constraint x + 2 * y <= max_combined;

% Minimum strategic requirement: 3*x - y >= 50
constraint 3 * x - y >= min_requirement;


% Objective
solve minimize total_cost;