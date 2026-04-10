% Cleaning chemicals optimization (all data embedded)

% Parameters (from description)
int: time_cleanse = 4;          % time units per unit of cleansing chemical
int: time_odor    = 6;          % minutes per unit of odor-removing chemical
int: min_cleanse  = 100;        % at least 100 units of cleansing chemical
int: min_total    = 300;        % at least 300 units total
int: max_total    = 100000;     % safe upper bound for search

% Decision variables
var min_cleanse..max_total: x;  % units of cleansing chemical
var 0..max_total: y;            % units of odor-removing chemical

% Constraints
constraint x + y >= min_total;
constraint x <= 2 * y;          % at most twice as much cleansing as odor-removing

% Objective: minimize total time
var int: total_time = time_cleanse * x + time_odor * y;

solve minimize total_time;

output [
  "Cleansing units (x) = ", show(x), "\n",
  "Odor-removing units (y) = ", show(y), "\n",
  "Total time = ", show(total_time), "\n"
];