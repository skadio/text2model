% Parameters
int: total_acres = 100;                % Total available farm area (acres)

int: profit_corn = 1500;               % Profit per acre for corn
int: profit_wheat = 1200;              % Profit per acre for wheat
int: profit_soybeans = 1800;           % Profit per acre for soybeans
int: profit_sorghum = 1600;            % Profit per acre for sorghum


% Variables
var 0..total_acres: acres_corn;        % Acres allocated to corn
var 0..total_acres: acres_wheat;       % Acres allocated to wheat
var 0..total_acres: acres_soybeans;    % Acres allocated to soybeans
var 0..total_acres: acres_sorghum;     % Acres allocated to sorghum

var 0..(total_acres * max([profit_corn, profit_wheat, profit_soybeans, profit_sorghum])): total_profit;
                                      % Total profit (bounded by all acres in best crop)


% Constraints
% Land usage: do not exceed total available acres
constraint
  acres_corn + acres_wheat + acres_soybeans + acres_sorghum <= total_acres;

% Corn acres must be at least twice wheat acres
constraint
  acres_corn >= 2 * acres_wheat;

% Soybeans acres must be at least half sorghum acres (avoid fractions)
constraint
  2 * acres_soybeans >= acres_sorghum;

% Wheat acres must be three times sorghum acres
constraint
  acres_wheat = 3 * acres_sorghum;

% Define total profit from crop allocations
constraint
  total_profit =
    profit_corn * acres_corn +
    profit_wheat * acres_wheat +
    profit_soybeans * acres_soybeans +
    profit_sorghum * acres_sorghum;


% Objective
solve maximize total_profit;