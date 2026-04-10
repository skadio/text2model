include "globals.mzn";

% Data (embedded from problem statement)
float: pain1 = 0.2;
float: anx1  = 0.3;
float: dis1  = 0.3;

float: pain2 = 0.6;
float: anx2  = 0.2;
float: dis2  = 0.1;

float: pain_max = 6.0;
float: anx_min  = 3.0;

% Decision variables: number of pills (nonnegative integers)
var 0..100: x1; % Pill 1 count
var 0..100: x2; % Pill 2 count

% Constraints
constraint pain1 * int2float(x1) + pain2 * int2float(x2) <= pain_max;
constraint anx1  * int2float(x1) + anx2  * int2float(x2) >= anx_min;

% Objective: minimize total discharge
var float: total_discharge = dis1 * int2float(x1) + dis2 * int2float(x2);

solve minimize total_discharge;

output [
  "Pill1 = ", show(x1), "\n",
  "Pill2 = ", show(x2), "\n",
  "Total discharge = ", show(total_discharge), "\n",
  "Pain provided = ", show(pain1 * int2float(x1) + pain2 * int2float(x2)), "\n",
  "Anxiety provided = ", show(anx1 * int2float(x1) + anx2 * int2float(x2)), "\n"
];