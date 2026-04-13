% Parameters
int: total_acres = 1000;               % Total available acres on the farm
int: revenue_wheat = 2;                % Revenue per acre of wheat ($/acre)
int: revenue_corn  = 3;                % Revenue per acre of corn ($/acre)
int: revenue_barley = 1;               % Revenue per acre of barley ($/acre)

int: min_wheat_corn_requirement = 500; % Constraint: 2*wheat + corn >= 500
int: max_wheat_barley_limit = 600;     % Constraint: wheat + 2*barley <= 600


% Variables
var 0..total_acres: acres_wheat;       % Acres allocated to wheat (integer, nonnegative)
var 0..total_acres: acres_corn;        % Acres allocated to corn (integer, nonnegative)
var 0..total_acres: acres_barley;      % Acres allocated to barley (integer, nonnegative)

% Upper bound: planting all acres with the highest-revenue crop (corn)
var 0..(revenue_wheat*total_acres + revenue_corn*total_acres + revenue_barley*total_acres): total_revenue;


% Constraints
% Total acreage capacity (cannot exceed available farm size)
constraint
  acres_wheat + acres_corn + acres_barley <= total_acres;

% Wheat vs. corn requirement: 2*wheat + corn must meet minimum threshold
constraint
  2 * acres_wheat + acres_corn >= min_wheat_corn_requirement;

% Wheat vs. barley limit: wheat + 2*barley must not exceed maximum threshold
constraint
  acres_wheat + 2 * acres_barley <= max_wheat_barley_limit;

% Define total revenue from planted acres
constraint
  total_revenue =
    revenue_wheat * acres_wheat +
    revenue_corn  * acres_corn +
    revenue_barley * acres_barley;


% Objective
solve minimize total_revenue;

output [
  "acres_wheat=", show(acres_wheat), "\n",
  "acres_corn=", show(acres_corn), "\n",
  "acres_barley=", show(acres_barley), "\n",
  "total_revenue=$", show(total_revenue), "\n"
];