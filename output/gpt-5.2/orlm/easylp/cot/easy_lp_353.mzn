% Parameters (with values embedded)
int: cost_nurse = 2;
int: cost_doctor = 3;
int: cost_equipment = 4;
int: cost_medicine = 5;

int: min_staff = 50;          % nurse + doctor >= 50
int: max_storage = 100;       % equipment + medicine <= 100
int: min_nurse_over_equip = 10; % nurse >= equipment + 10
int: max_doc_med_diff = 20;   % |doctor - medicine| <= 20

% Upper limits (explicit finite bounds for all variables)
int: max_nurse = 1000;
int: max_doctor = 1000;
int: max_equipment = 1000;
int: max_medicine = 1000;

% Variables
var 0..max_nurse: nurse;
var 0..max_doctor: doctor;
var 0..max_equipment: equipment;
var 0..max_medicine: medicine;

var int: total_cost;

% Constraints
constraint nurse + doctor >= min_staff;
constraint equipment + medicine <= max_storage;
constraint nurse >= equipment + min_nurse_over_equip;
constraint abs(doctor - medicine) <= max_doc_med_diff;

constraint total_cost = cost_nurse*nurse
                      + cost_doctor*doctor
                      + cost_equipment*equipment
                      + cost_medicine*medicine;

% Objective
solve minimize total_cost;