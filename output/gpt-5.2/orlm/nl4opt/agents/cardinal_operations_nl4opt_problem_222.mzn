% Parameters
int: total_gold_mg = 1000;              % Total available gold (mg)
int: gold_per_long_mg = 10;             % Gold required per long cable (mg)
int: gold_per_short_mg = 7;             % Gold required per short cable (mg)

int: min_long = 10;                     % Minimum number of long cables
int: short_to_long_ratio = 5;           % At least this many short cables per long cable

int: profit_long = 12;                  % Profit per long cable ($)
int: profit_short = 5;                  % Profit per short cable ($)

% Variables
var 0..(total_gold_mg div gold_per_long_mg): num_long;    % Number of long cables to make
var 0..(total_gold_mg div gold_per_short_mg): num_short;  % Number of short cables to make

var 0..(profit_long * (total_gold_mg div gold_per_long_mg)
        + profit_short * (total_gold_mg div gold_per_short_mg)): total_profit; % Total profit ($)

% Constraints
% Gold usage must not exceed available supply
constraint
  gold_per_long_mg * num_long + gold_per_short_mg * num_short <= total_gold_mg;

% Minimum production requirement for long cables
constraint
  num_long >= min_long;

% Ratio requirement: at least 5 times as many short cables as long cables
constraint
  num_short >= short_to_long_ratio * num_long;

% Define total profit from chosen production quantities
constraint
  total_profit = profit_long * num_long + profit_short * num_short;

% Objective
solve maximize total_profit;

output [
  "num_long = ", show(num_long), "\n",
  "num_short = ", show(num_short), "\n",
  "total_profit = ", show(total_profit), "\n"
];