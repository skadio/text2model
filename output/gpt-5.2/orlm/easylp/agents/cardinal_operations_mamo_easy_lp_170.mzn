% Parameters
% Budget limits and requirements (all in dollars)
int: max_budget_XY = 1000;      % X + Y cannot exceed this
int: max_budget_YZ = 800;       % Y + Z cannot exceed this
int: min_budget_XZ = 500;       % X + Z must be at least this

% Cost per unit of effectiveness (dollars per unit)
int: cost_X = 5;
int: cost_Y = 4;
int: cost_Z = 3;

% Upper bounds for decision variables derived from constraints
int: ub_X = max_budget_XY;                      % since X <= X+Y <= 1000
int: ub_Y = min(max_budget_XY, max_budget_YZ);  % Y <= 1000 and Y <= 800
int: ub_Z = max_budget_YZ;                      % since Z <= Y+Z <= 800


% Variables
var 0..ub_X: X;  % integer spend/effectiveness units for channel X
var 0..ub_Y: Y;  % integer spend/effectiveness units for channel Y
var 0..ub_Z: Z;  % integer spend/effectiveness units for channel Z

% Total cost variable (upper bound based on variable upper bounds)
var 0..(cost_X * ub_X + cost_Y * ub_Y + cost_Z * ub_Z): total_cost;


% Constraints
% --- Budget limit constraints (resource caps) ---
constraint X + Y <= max_budget_XY;  % Channel X and Y combined cannot exceed max_budget_XY
constraint Y + Z <= max_budget_YZ;  % Channel Y and Z combined cannot exceed max_budget_YZ

% --- Minimum campaign requirement constraint (reach/frequency) ---
constraint X + Z >= min_budget_XZ;  % Channel X and Z combined must be at least min_budget_XZ

% --- Total cost definition constraint (linking variable) ---
constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;  % Compute total cost


% Objective
solve minimize total_cost;