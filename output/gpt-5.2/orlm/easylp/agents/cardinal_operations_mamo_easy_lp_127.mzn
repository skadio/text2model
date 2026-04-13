% Parameters
int: benefit_X = 4;          % Benefit score per unit allocated to program X
int: benefit_Y = 3;          % Benefit score per unit allocated to program Y

int: min_impact = 10;        % Minimum required overall impact (RHS of 2*X + Y >= 10)
int: max_budget = 30;        % Maximum allowed budget/effort (RHS of X + 3*Y <= 30)

% Variable upper bounds (non-negative integer allocations)
int: X_ub = 30;
int: Y_ub = 10;

% Variables
var 0..X_ub: x;              % Whole units allocated to program X
var 0..Y_ub: y;              % Whole units allocated to program Y

% Constraints

% Minimum overall impact requirement
constraint 2 * x + y >= min_impact;

% Maximum budget/effort limit
constraint x + 3 * y <= max_budget;

% Objective
solve minimize benefit_X * x + benefit_Y * y;