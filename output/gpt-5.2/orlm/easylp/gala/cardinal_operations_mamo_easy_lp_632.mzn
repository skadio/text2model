include "globals.mzn";

% Four training sessions:
% x1 = endurance, x2 = strength, x3 = agility, x4 = tactics
set of int: SESS = 1..4;

array[SESS] of int: fatigue_per_hour = [1000, 1500, 2000, 2500];

% Decision variables: whole hours per week for each session
array[SESS] of var 0..100: x;  % upper bound is safe; actual bounds come from constraints

% Constraints
constraint x[1] + x[2] <= 20;      % endurance + strength
constraint x[3] + x[4] <= 15;      % agility + tactics
constraint x[1] + x[3] >= 10;      % endurance + agility at least 10
constraint x[2] + x[4] >= 8;       % strength + tactics at least 8

% Objective: minimize total fatigue score
var int: total_fatigue = sum(i in SESS)(fatigue_per_hour[i] * x[i]);

solve minimize total_fatigue;

output [
  "x1(endurance) = ", show(x[1]), "\n",
  "x2(strength)  = ", show(x[2]), "\n",
  "x3(agility)   = ", show(x[3]), "\n",
  "x4(tactics)   = ", show(x[4]), "\n",
  "Minimum total fatigue = ", show(total_fatigue), "\n"
];