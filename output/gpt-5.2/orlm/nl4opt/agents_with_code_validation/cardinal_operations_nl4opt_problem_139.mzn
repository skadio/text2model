% Parameters
int: eggs_per_regular = 2;          % eggs needed for one regular sandwich
int: bacon_per_regular = 3;         % bacon slices needed for one regular sandwich
int: eggs_per_special = 3;          % eggs needed for one special sandwich
int: bacon_per_special = 5;         % bacon slices needed for one special sandwich

int: total_eggs = 40;               % total eggs available
int: total_bacon = 70;              % total bacon slices available

int: profit_regular = 3;            % profit per regular sandwich
int: profit_special = 4;            % profit per special sandwich

% Variables
var 0..(total_eggs div eggs_per_regular): regular_sandwiches;  % number of regular sandwiches to make
var 0..(total_eggs div eggs_per_special): special_sandwiches;  % number of special sandwiches to make

% Upper bound is a safe profit bound based on egg-limited max counts
var 0..(profit_regular*(total_eggs div eggs_per_regular) + profit_special*(total_eggs div eggs_per_special)): total_profit;

% Constraints
% Do not exceed available eggs
constraint
  eggs_per_regular * regular_sandwiches
+ eggs_per_special * special_sandwiches
<= total_eggs;

% Do not exceed available bacon
constraint
  bacon_per_regular * regular_sandwiches
+ bacon_per_special * special_sandwiches
<= total_bacon;

% Define total profit
constraint
  total_profit =
    profit_regular * regular_sandwiches
  + profit_special * special_sandwiches;

% Objective
solve maximize total_profit;