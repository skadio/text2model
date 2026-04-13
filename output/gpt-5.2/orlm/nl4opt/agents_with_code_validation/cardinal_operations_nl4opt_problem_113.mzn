% Parameters
int: total_acres = 50;                 % Total acres available
int: min_apples_acres = 5;             % Minimum acres of apples required
int: min_pears_acres = 10;             % Minimum acres of pears required
int: profit_per_apple = 2;             % Profit per acre of apples ($)
int: profit_per_pear = 4;              % Profit per acre of pears ($)
int: max_pears_per_apple_ratio = 2;    % Workforce limit: pears <= 2 * apples

% Variables
var min_apples_acres..total_acres: apples_acres;   % Acres allocated to apples
var min_pears_acres..total_acres: pears_acres;     % Acres allocated to pears
var 0..(profit_per_apple * total_acres + profit_per_pear * total_acres): total_profit; % Total profit ($)

% Constraints
% Land availability: total acres allocated cannot exceed the available land
constraint
  apples_acres + pears_acres <= total_acres;

% Workforce ratio limitation: pears can be at most twice the apples acreage
constraint
  pears_acres <= max_pears_per_apple_ratio * apples_acres;

% Profit definition: link total_profit to the acres allocated and per-acre profits
constraint
  total_profit = profit_per_apple * apples_acres + profit_per_pear * pears_acres;

% Objective
solve maximize total_profit;