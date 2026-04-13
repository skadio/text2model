% Parameters
% Resource requirements per sandwich type
int: eggs_per_regular = 2;
int: bacon_per_regular = 3;
int: eggs_per_special = 3;
int: bacon_per_special = 5;

% Available resources
int: total_eggs = 40;
int: total_bacon = 70;

% Profit per sandwich type
int: profit_regular = 3;
int: profit_special = 4;

% Variables
% Decision variables: number of sandwiches to make (non-negative integers)
var 0..(total_eggs div eggs_per_regular): regular_sandwiches;
var 0..(total_eggs div eggs_per_special): special_sandwiches;

% Total profit (bounded for safety in linear expressions)
var 0..(profit_regular*(total_eggs div eggs_per_regular) + profit_special*(total_eggs div eggs_per_special)): total_profit;

% Constraints
% Resource capacity constraints (eggs and bacon must not exceed availability)
constraint
  eggs_per_regular * regular_sandwiches
+ eggs_per_special * special_sandwiches
<= total_eggs;

constraint
  bacon_per_regular * regular_sandwiches
+ bacon_per_special * special_sandwiches
<= total_bacon;

% Profit definition constraint (link total_profit to decision variables)
constraint
  total_profit
= profit_regular * regular_sandwiches
+ profit_special * special_sandwiches;

% Objective
solve maximize total_profit;