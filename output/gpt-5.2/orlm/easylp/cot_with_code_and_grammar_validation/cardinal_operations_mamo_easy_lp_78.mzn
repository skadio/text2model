% Parameters
int: req_min = 8;          % 2*X + Y >= 8
int: budget_max = 15;      % X + 3*Y <= 15
int: cost_X = 5000;        % cost per worker on Project X
int: cost_Y = 3000;        % cost per worker on Project Y

% Variable bounds derived from constraints and non-negativity
int: X_ub = budget_max;                 % since X <= X + 3Y <= 15
int: Y_ub = budget_max div 3;           % since 3Y <= 15 -> Y <= 5

% Variables
var 0..X_ub: X;          % workers on Project X (integer)
var 0..Y_ub: Y;          % workers on Project Y (integer)
var 0..(cost_X*X_ub + cost_Y*Y_ub): total_cost;

% Constraints
constraint 2*X + Y >= req_min;
constraint X + 3*Y <= budget_max;
constraint total_cost = cost_X*X + cost_Y*Y;

% Objective
solve minimize total_cost;