% Radiation treatment optimization (LP)

% Parameters (dose per minute)
float: p1 = 0.3;  % pancreas from beam 1
float: s1 = 0.2;  % skin from beam 1
float: t1 = 0.6;  % tumor from beam 1

float: p2 = 0.2;  % pancreas from beam 2
float: s2 = 0.1;  % skin from beam 2
float: t2 = 0.4;  % tumor from beam 2

float: skin_max = 4.0;
float: tumor_min = 3.0;

% Variables (minutes of each beam), nonnegative
var float: x1;
var float: x2;

% Constraints
constraint x1 >= 0.0 /\ x2 >= 0.0;
constraint s1 * x1 + s2 * x2 <= skin_max;
constraint t1 * x1 + t2 * x2 >= tumor_min;

% Objective: minimize pancreas dose
var float: pancreas_dose = p1 * x1 + p2 * x2;
solve minimize pancreas_dose;

output [
  "x1 (beam 1 minutes) = ", show(x1), "\n",
  "x2 (beam 2 minutes) = ", show(x2), "\n",
  "pancreas dose = ", show(pancreas_dose), "\n"
];