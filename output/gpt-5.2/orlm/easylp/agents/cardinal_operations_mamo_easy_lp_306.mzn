% Parameters
% Project costs (unit cost per allocated fund unit)
int: cost_X = 2;
int: cost_Y = 3;
int: cost_Z = 4;

% Budget and policy limits
int: total_budget_max = 100;     % X + Y + Z <= 100
int: policy_min = 20;            % 2*X - Y >= 20
int: yz_budget_max = 70;         % Y + Z <= 70

% Allocation bounds
int: X_max = 50;                 % X <= 50
int: Y_max = 40;                 % Y <= 40
% Z has no explicit upper bound; bounded implicitly by total_budget_max and yz_budget_max

% Variables
var 0..X_max: X;                 % funds allocated to project X (integer)
var 0..Y_max: Y;                 % funds allocated to project Y (integer)
var 0..total_budget_max: Z;      % funds allocated to project Z (integer, safe upper bound)

% Objective variable (for clarity)
var 0..(cost_X*X_max + cost_Y*Y_max + cost_Z*total_budget_max): total_cost;

% Constraints
% Budget feasibility constraints
constraint X + Y + Z <= total_budget_max;   % Total allocation cannot exceed overall budget
constraint Y + Z <= yz_budget_max;          % Combined allocation for Y and Z cannot exceed its cap

% Policy constraint
constraint 2 * X - Y >= policy_min;         % Enforce minimum policy requirement

% Cost accounting constraint
constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;