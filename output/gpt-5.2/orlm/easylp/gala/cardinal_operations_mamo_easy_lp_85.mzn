% Shift scheduling cost minimization (all data embedded)

% Decision variables: number of shifts for each worker type
var 0..1000: xShifts;   % type X shifts (integer)
var 0..1000: yShifts;   % type Y shifts (integer)

% Constraints
constraint xShifts + yShifts >= 10;
constraint xShifts <= 2 * yShifts + 4;

% Objective: minimize total wage cost
var int: totalCost = 8 * xShifts + 5 * yShifts;

solve minimize totalCost;

output [
  "xShifts = ", show(xShifts), "\n",
  "yShifts = ", show(yShifts), "\n",
  "minTotalCost = $", show(totalCost), "\n"
];