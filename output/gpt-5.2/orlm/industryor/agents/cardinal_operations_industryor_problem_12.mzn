% Parameters
int: total_acres = 100;                 % Total available farm area (acres)

int: profit_corn = 1500;                % Profit per acre for corn ($/acre)
int: profit_wheat = 1200;               % Profit per acre for wheat ($/acre)
int: profit_soybeans = 1800;            % Profit per acre for soybeans ($/acre)
int: profit_sorghum = 1600;             % Profit per acre for sorghum ($/acre)

% Variables
var 0..total_acres: acres_corn;         % Acres allocated to corn
var 0..total_acres: acres_wheat;        % Acres allocated to wheat
var 0..total_acres: acres_soybeans;     % Acres allocated to soybeans
var 0..total_acres: acres_sorghum;      % Acres allocated to sorghum

var 0..(total_acres * max([profit_corn, profit_wheat, profit_soybeans, profit_sorghum])): total_profit;
                                        % Total profit ($), bounded by allocating all acres to best crop

% Constraints

% Land usage constraint: total allocated acres cannot exceed available farm area
constraint
  acres_corn + acres_wheat + acres_soybeans + acres_sorghum <= total_acres;

% Crop ratio constraints from problem statement
constraint
  acres_corn >= 2 * acres_wheat;                 % Corn at least twice wheat

constraint
  2 * acres_soybeans >= acres_sorghum;           % Soybeans at least half sorghum (avoid fractions)

constraint
  acres_wheat = 3 * acres_sorghum;               % Wheat is three times sorghum

% Total profit definition (ties profit to chosen acre allocations)
constraint
  total_profit =
    profit_corn * acres_corn +
    profit_wheat * acres_wheat +
    profit_soybeans * acres_soybeans +
    profit_sorghum * acres_sorghum;

% Objective
solve maximize total_profit;

output [
  "acres_corn = ", show(acres_corn), "\n",
  "acres_wheat = ", show(acres_wheat), "\n",
  "acres_soybeans = ", show(acres_soybeans), "\n",
  "acres_sorghum = ", show(acres_sorghum), "\n",
  "total_profit = ", show(total_profit), "\n"
];