% Parameters
int: cost_house = 400000;          % Investment cost per house
int: cost_apartment = 600000;      % Investment cost per apartment

float: value_house = 1.5;          % Contribution to combined value per house
float: value_apartment = 2.0;      % Contribution to combined value per apartment
float: min_total_value = 500.0;    % Minimum required combined value

float: workload_house = 0.75;      % Workload contribution per house
float: workload_apartment = 1.0;   % Workload contribution per apartment
float: max_total_workload = 300.0; % Maximum allowed total workload

% Variables
var int: x;                        % Number of houses to build (integer)
var int: y;                        % Number of apartments to build (integer)
var int: total_investment;         % Total investment to minimize (in dollars)

% Constraints
% Non-negativity bounds
constraint x >= 0;
constraint y >= 0;

% Link total investment
constraint total_investment = cost_house * x + cost_apartment * y;

% --- Market demand: ensure minimum combined value is met ---
% 1.5*x + 2.0*y >= 500.0
constraint
  value_house * int2float(x) + value_apartment * int2float(y) >= min_total_value;

% --- Capacity limit: ensure total workload does not exceed maximum ---
% 0.75*x + 1.0*y <= 300.0
constraint
  workload_house * int2float(x) + workload_apartment * int2float(y) <= max_total_workload;

% Objective
solve minimize total_investment;