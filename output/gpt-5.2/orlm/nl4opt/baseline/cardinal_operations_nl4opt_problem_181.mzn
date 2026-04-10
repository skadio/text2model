% Medication units decision variables
var int: anxiety;         % units of anxiety medication
var int: antidepressant;  % units of anti-depressant

% Constraints
constraint anxiety >= 30;
constraint anxiety + antidepressant >= 100;
constraint anxiety <= 2 * antidepressant;
constraint anxiety >= 0 /\ antidepressant >= 0;

% Objective: minimize total time (minutes) to become effective
var int: total_time = 3 * anxiety + 5 * antidepressant;
solve minimize total_time;

output [
  "anxiety_units = ", show(anxiety), "\n",
  "antidepressant_units = ", show(antidepressant), "\n",
  "total_units = ", show(anxiety + antidepressant), "\n",
  "total_time = ", show(total_time), " minutes\n"
];