% Parameters
int: cost_nurse = 2;
int: cost_doctor = 3;
int: cost_equipment = 4;
int: cost_medicine = 5;

int: min_nurse_doctor = 50;
int: max_equipment_medicine = 100;
int: min_nurse_minus_equipment = 10;
int: max_abs_doctor_minus_medicine = 20;

int: ub_nurse = 1000;
int: ub_doctor = 1000;
int: ub_equipment = 1000;
int: ub_medicine = 1000;

% Variables
var 0..ub_nurse: nurse;
var 0..ub_doctor: doctor;
var 0..ub_equipment: equipment;
var 0..ub_medicine: medicine;

var 0..(cost_nurse*ub_nurse + cost_doctor*ub_doctor + cost_equipment*ub_equipment + cost_medicine*ub_medicine): total_cost;

% Constraints
constraint nurse + doctor >= min_nurse_doctor;

constraint equipment + medicine <= max_equipment_medicine;

constraint nurse - equipment >= min_nurse_minus_equipment;

constraint abs(doctor - medicine) <= max_abs_doctor_minus_medicine;

constraint total_cost = cost_nurse*nurse + cost_doctor*doctor + cost_equipment*equipment + cost_medicine*medicine;

% Objective
solve minimize total_cost;