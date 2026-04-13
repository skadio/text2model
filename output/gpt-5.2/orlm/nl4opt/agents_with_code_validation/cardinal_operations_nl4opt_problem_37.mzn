% Parameters
% Time requirements (minutes per jar)
int: shaping_time_thin   = 50;
int: baking_time_thin    = 90;
int: shaping_time_stubby = 30;
int: baking_time_stubby  = 150;

% Weekly available time (minutes)
int: shaping_available = 3000;
int: baking_available  = 4000;

% Profit per jar (dollars per jar)
int: profit_thin   = 5;
int: profit_stubby = 9;

% Variables
% Number of jars to produce (non-negative integers), bounded by shaping-time maxima
var 0..(shaping_available div shaping_time_thin): thin_jars;
var 0..(shaping_available div shaping_time_stubby): stubby_jars;

% Total profit (safe upper bound using shaping-time-only maxima)
var 0..(profit_thin*(shaping_available div shaping_time_thin)
        + profit_stubby*(shaping_available div shaping_time_stubby)): total_profit;

% Constraints
% Resource capacity constraints (weekly time limits)
constraint
  shaping_time_thin * thin_jars + shaping_time_stubby * stubby_jars
  <= shaping_available;

constraint
  baking_time_thin * thin_jars + baking_time_stubby * stubby_jars
  <= baking_available;

% Profit accounting constraint (link total_profit to decision variables)
constraint
  total_profit = profit_thin * thin_jars + profit_stubby * stubby_jars;

% Objective
solve maximize total_profit;