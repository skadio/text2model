% Parameters
int: fatigue_per_training = 6;
int: fatigue_per_equipment = 4;

% Variables
var 0..1000: training_hours;
var 0..1000: equipment_units;
var 0..100000: total_fatigue;

% Constraints
constraint 3 * training_hours + 2 * equipment_units >= 15;
constraint 4 * training_hours + 3 * equipment_units <= 50;

constraint total_fatigue = fatigue_per_training * training_hours
                         + fatigue_per_equipment * equipment_units;

% Objective
solve minimize total_fatigue;