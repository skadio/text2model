% Parameters
% All data is embedded directly (no .dzn expected).

int: max_logistics = 50;          % Upper bound for 2*X + 3*Y
int: min_strength = 10;           % Lower bound for 5*X + Y
int: max_diff = 5;                % |X - Y| <= 5

int: cost_x = 10;                 % Cost per unit X (in thousands)
int: cost_y = 20;                 % Cost per unit Y (in thousands)

% Derived safe upper bounds for decision variables (bounded domains)
int: ub_x = max_logistics div 2;  % Since 2*X <= 50 => X <= 25
int: ub_y = max_logistics div 3;  % Since 3*Y <= 50 => Y <= 16


% Variables
var 0..ub_x: x;                   % Number of X units (integer, nonnegative)
var 0..ub_y: y;                   % Number of Y units (integer, nonnegative)

% Total cost (in thousands); bounded using max possible values within domains
var 0..(cost_x * ub_x + cost_y * ub_y): total_cost;


% Constraints
% Logistics capacity: 2*X + 3*Y <= 50
constraint 2 * x + 3 * y <= max_logistics;

% Minimum strength requirement: 5*X + Y >= 10
constraint 5 * x + y >= min_strength;

% Allocation difference limit: |X - Y| <= 5
constraint abs(x - y) <= max_diff;

% Define total cost (in thousands): 10*X + 20*Y
constraint total_cost = cost_x * x + cost_y * y;


% Objective
solve minimize total_cost;