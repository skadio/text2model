% Parameters (with values embedded)
int: patients_required = 320;

int: cap_ambulance = 20;
int: cap_van = 15;

int: cost_ambulance = 820;
int: cost_van = 550;

float: max_van_fraction = 0.60;

% Variables
var 0..patients_required: shifts_ambulance;
var 0..patients_required: shifts_van;

% Constraints
constraint cap_ambulance * shifts_ambulance + cap_van * shifts_van >= patients_required;

% At most 60% of shifts are vans:
% shifts_van <= 0.60 * (shifts_ambulance + shifts_van)
% Equivalent linear integer form: 2*shifts_van <= 3*shifts_ambulance
constraint 2 * shifts_van <= 3 * shifts_ambulance;

% Objective
solve minimize cost_ambulance * shifts_ambulance + cost_van * shifts_van;