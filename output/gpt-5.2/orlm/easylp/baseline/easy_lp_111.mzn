% Resource allocation: training hours (x) and equipment cost units (y)
% Minimize total fatigue = 6x + 4y subject to:
% 3x + 2y >= 15
% 4x + 3y <= 50
% x, y are integers and nonnegative.

int: min_x = 0;
int: min_y = 0;

% Conservative upper bounds derived from constraints
int: max_x = 12; % from 4x <= 50 => x <= 12
int: max_y = 16; % from 3y <= 50 => y <= 16

var min_x..max_x: x; % training hours
var min_y..max_y: y; % equipment cost units

constraint 3*x + 2*y >= 15;
constraint 4*x + 3*y <= 50;

var int: fatigue = 6*x + 4*y;

solve minimize fatigue;

output [
  "training_hours = ", show(x), "\n",
  "equipment_units = ", show(y), "\n",
  "min_total_fatigue (rounded) = ", show(fatigue), "\n"
];