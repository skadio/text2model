% Parameters
int: total_acres = 50;                 % Total available acres
int: min_apples_acres = 5;             % Minimum acres of apples to meet demand
int: min_pears_acres = 10;             % Minimum acres of pears to meet demand
int: profit_per_apple = 2;             % Profit per acre of apples ($)
int: profit_per_pear  = 4;             % Profit per acre of pears ($)
int: max_pears_ratio  = 2;             % Workforce limit: pears <= max_pears_ratio * apples

% Variables
var min_apples_acres..total_acres: acres_apples;  % Acres allocated to apples
var min_pears_acres..total_acres: acres_pears;    % Acres allocated to pears
var 0..(profit_per_apple * total_acres + profit_per_pear * total_acres): total_profit; % Total profit ($)

% Constraints
% Land availability: total planted acres cannot exceed available land
constraint acres_apples + acres_pears <= total_acres;

% Preference/feasibility: Ben grows at least as many pears as apples
constraint acres_pears >= acres_apples;

% Workforce limitation: pears are at most a multiple of apples
constraint acres_pears <= max_pears_ratio * acres_apples;

% Define total profit from planted acres
constraint total_profit = profit_per_apple * acres_apples + profit_per_pear * acres_pears;

% Objective
solve maximize total_profit;