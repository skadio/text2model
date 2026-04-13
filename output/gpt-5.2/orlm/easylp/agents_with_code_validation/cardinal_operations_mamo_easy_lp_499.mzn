% Parameters
int: min_total_properties = 50;              % Minimum total number of properties (X + Y)
int: max_weighted_properties = 120;          % Maximum allowed for 2*X + Y
int: min_balance = 10;                       % Minimum required for (X - 3*Y)
int: min_residential = 20;                   % Minimum residential properties X
int: min_commercial = 10;                    % Minimum commercial properties Y
int: cost_residential = 5000;                % Cost per residential unit
int: cost_commercial = 3000;                 % Cost per commercial unit

% Variables
var int: X;                                  % Number of residential properties (integer units)
var int: Y;                                  % Number of commercial properties (integer units)
var int: total_cost;                         % Total investment cost in dollars

% Constraints
% --- Minimum investment requirements ---
constraint X >= min_residential;
constraint Y >= min_commercial;

% --- At least the minimum total properties ---
constraint X + Y >= min_total_properties;

% --- Weighted upper bound on investments ---
constraint 2 * X + Y <= max_weighted_properties;

% --- Portfolio balance requirement ---
constraint X - 3 * Y >= min_balance;

% --- Total cost definition ---
constraint total_cost = cost_residential * X + cost_commercial * Y;

% Objective
solve minimize total_cost;