% Cleaning chemicals mix optimization (all data embedded)

% Decision variables: units of each chemical
var 0..10000: cleansing_units;
var 0..10000: odor_units;

% Parameters (time per unit)
int: time_cleansing = 4;
int: time_odor = 6;

% Constraints
constraint cleansing_units >= 100;                 % at least 100 units of cleansing
constraint cleansing_units + odor_units >= 300;    % at least 300 total units
constraint cleansing_units <= 2 * odor_units;      % at most twice as much cleansing as odor

% Objective: minimize total time
var int: total_time = time_cleansing * cleansing_units + time_odor * odor_units;
solve minimize total_time;

output [
  "cleansing_units=", show(cleansing_units), "\n",
  "odor_units=", show(odor_units), "\n",
  "total_time=", show(total_time), "\n"
];