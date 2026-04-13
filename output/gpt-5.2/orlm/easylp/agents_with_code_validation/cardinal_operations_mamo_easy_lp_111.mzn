% Parameters
% Coefficients for constraint 1: 3*trainingHours - 2*equipmentUnits >= 15
int: a1 = 3;
int: b1 = 2;
int: c1 = 15;

% Coefficients for constraint 2: 4*trainingHours - 3*equipmentUnits <= 50
int: a2 = 4;
int: b2 = 3;
int: c2 = 50;

% Fatigue coefficients
int: fatigueTraining = 6;     % fatigue per training hour
int: fatigueEquipment = 4;    % fatigue per equipment unit

% Generic variable bounds (non-negative due to practical considerations)
int: maxTraining = 1000;
int: maxEquipment = 1000;

% Variables
var 0..maxTraining: trainingHours;    % integer number of training hours
var 0..maxEquipment: equipmentUnits;  % integer units of equipment cost

var int: totalFatigue;               % total fatigue score (objective)

% Constraints

% --- Link total fatigue to decision variables ---
constraint
  totalFatigue = fatigueTraining * trainingHours + fatigueEquipment * equipmentUnits;

% --- Resource ratio + minimum combined requirement (constraint 1) ---
constraint
  a1 * trainingHours - b1 * equipmentUnits >= c1;

% --- Resource ratio + maximum combined limit (constraint 2) ---
constraint
  a2 * trainingHours - b2 * equipmentUnits <= c2;

% Objective
solve minimize totalFatigue;