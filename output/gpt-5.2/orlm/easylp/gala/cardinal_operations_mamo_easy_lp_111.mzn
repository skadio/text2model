% Sports team resource allocation (integer optimization)

% Decision variables (integers)
var int: training_hours;
var int: equipment_units;

% Keep variables nonnegative (practical interpretation)
constraint training_hours >= 0;
constraint equipment_units >= 0;

% Constraints from the description:
% For every 3 hours of training, at least 2 units of equipment, and combined value >= 15
constraint 3 * training_hours + 2 * equipment_units >= 15;

% For every 4 hours of training, no more than 3 units of equipment, and combined value <= 50
constraint 4 * training_hours + 3 * equipment_units <= 50;

% Objective: minimize total fatigue score
% (6 per training hour, 4 per equipment unit)
var int: total_fatigue = 6 * training_hours + 4 * equipment_units;

solve minimize total_fatigue;

output [
  "training_hours = ", show(training_hours), "\n",
  "equipment_units = ", show(equipment_units), "\n",
  "min_total_fatigue (rounded) = ", show(total_fatigue), "\n"
];