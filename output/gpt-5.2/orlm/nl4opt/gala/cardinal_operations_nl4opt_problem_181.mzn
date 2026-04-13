include "globals.mzn";

% Data (embedded from problem statement)
int: time_anxiety = 3;          % minutes per unit
int: time_antidepressant = 5;   % minutes per unit
int: min_total_units = 100;
int: min_anxiety_units = 30;

% Decision variables
var 0..1000: anxiety;           % units of anxiety medication
var 0..1000: antidepressant;    % units of anti-depressant

% Total time to become effective (sequential)
var 0..100000: total_time = time_anxiety * anxiety + time_antidepressant * antidepressant;

% Constraints
constraint anxiety + antidepressant >= min_total_units;
constraint anxiety >= min_anxiety_units;
constraint anxiety <= 2 * antidepressant;

solve minimize total_time;

output [
  "anxiety = ", show(anxiety), "\n",
  "antidepressant = ", show(antidepressant), "\n",
  "total_units = ", show(anxiety + antidepressant), "\n",
  "total_time = ", show(total_time), " minutes\n"
];