include "globals.mzn";

/*
Pool chemicals scheduling/selection.

Let:
  c = units of chlorine
  w = units of water softener

Effectiveness times:
  chlorine: 1 minute per unit
  softener: 2 minutes per unit

Safety constraint:
  c <= 0.5 * w  <=>  2c <= w

Requirements:
  c >= 200
  c + w = 500

"chlorine must be added before water softener or vice versa" -> two consecutive tasks.
Since order does not change the total completion time when tasks are sequential with no idle,
the objective is simply the total processing time: 1*c + 2*w.
*/

var 0..500: c;  % chlorine units
var 0..500: w;  % water softener units

% Order decision: 1 = chlorine then softener, 2 = softener then chlorine
var 1..2: order;

% Constraints
constraint c >= 200;
constraint c + w = 500;
constraint 2 * c <= w;

% Sequential time (makespan) for the two-task sequence
var int: total_time;
constraint total_time = 1 * c + 2 * w;

solve minimize total_time;

output [
  "chlorine_units = ", show(c), "\n",
  "softener_units = ", show(w), "\n",
  "order (1=C then W, 2=W then C) = ", show(order), "\n",
  "total_time_minutes = ", show(total_time), "\n"
];