% Parameters
int: fatigue_per_training_hour = 6;
int: fatigue_per_equipment_unit = 4;

int: train_ratio1 = 3;
int: equip_ratio1 = 2;
int: min_combined1 = 15;

int: train_ratio2 = 4;
int: equip_ratio2 = 3;
int: max_combined2 = 50;

% Variables
var 0..1000: training_hours;
var 0..1000: equipment_units;
var 0..100000: total_fatigue;

% Constraints
constraint train_ratio1 * training_hours + equip_ratio1 * equipment_units >= min_combined1;
constraint train_ratio2 * training_hours + equip_ratio2 * equipment_units <= max_combined2;

constraint total_fatigue = fatigue_per_training_hour * training_hours
                         + fatigue_per_equipment_unit * equipment_units;

% Objective
solve minimize total_fatigue;