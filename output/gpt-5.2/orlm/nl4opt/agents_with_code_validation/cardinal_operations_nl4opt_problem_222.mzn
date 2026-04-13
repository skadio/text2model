% Parameters
int: gold_available_mg = 1000;          % Total gold available (mg)
int: gold_per_long_mg  = 10;            % Gold required per long cable (mg)
int: gold_per_short_mg = 7;             % Gold required per short cable (mg)

int: min_long_cables = 10;              % Minimum number of long cables required
int: short_to_long_ratio = 5;           % At least this many short cables per long cable

int: profit_long  = 12;                 % Profit per long cable ($)
int: profit_short = 5;                  % Profit per short cable ($)

% Variables
var 0..(gold_available_mg div gold_per_long_mg): long_cables;    % Number of long cables to produce
var 0..(gold_available_mg div gold_per_short_mg): short_cables;  % Number of short cables to produce
var 0..(profit_long*(gold_available_mg div gold_per_long_mg)
       + profit_short*(gold_available_mg div gold_per_short_mg)): total_profit; % Total profit ($)

% Constraints

% Gold usage must not exceed available gold
constraint
  gold_per_long_mg * long_cables + gold_per_short_mg * short_cables
  <= gold_available_mg;

% Enforce minimum production of long cables
constraint
  long_cables >= min_long_cables;

% Short cables must be at least a given multiple of long cables
constraint
  short_cables >= short_to_long_ratio * long_cables;

% Define total profit from produced cables
constraint
  total_profit = profit_long * long_cables + profit_short * short_cables;

% Objective
solve maximize total_profit;

output [
  "long_cables = ", show(long_cables), "\n",
  "short_cables = ", show(short_cables), "\n",
  "total_profit = ", show(total_profit), "\n"
];