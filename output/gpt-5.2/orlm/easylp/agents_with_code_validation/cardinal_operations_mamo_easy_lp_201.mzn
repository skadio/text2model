% Parameters
int: budget = 1000;                 % Total investment budget cap
int: min_combo = 10;                % Minimum for (3*X + 2*Y - Z)
int: min_diff_zy = 30;              % Minimum for (Z - Y)

int: cost_x = 5;                    % Cost per unit invested in X
int: cost_y = 6;                    % Cost per unit invested in Y
int: cost_z = 7;                    % Cost per unit invested in Z

int: max_x = 500;                   % Maximum investment in X
int: max_y = 400;                   % Maximum investment in Y
int: min_z = 50;                    % Minimum investment in Z


% Variables
var 0..max_x: x;                    % Investment in portfolio X (integer units)
var 0..max_y: y;                    % Investment in portfolio Y (integer units)
var min_z..budget: z;               % Investment in portfolio Z (integer units)

% Upper bound is safe: worst case x=max_x, y=max_y, z=budget
var 0..(cost_x*max_x + cost_y*max_y + cost_z*budget): total_cost; % Total cost


% Constraints
% Budget cap: total allocation cannot exceed available budget
constraint x + y + z <= budget;

% Diversification / risk-return tradeoff requirement
constraint 3 * x + 2 * y - z >= min_combo;

% Exposure difference requirement between Z and Y
constraint z - y >= min_diff_zy;

% Total cost calculation based on per-unit costs
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;


% Objective
solve minimize total_cost;