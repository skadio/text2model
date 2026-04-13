% Parameters
int: cost_nurse = 2;
int: cost_doctor = 3;
int: cost_equipment = 4;
int: cost_medicine = 5;

int: min_staff = 50;                 % nurse + doctor >= 50
int: max_storage = 100;              % equipment + medicine <= 100
int: min_nurse_minus_equipment = 10; % nurse - equipment >= 10
int: max_doctor_medicine_diff = 20;  % |doctor - medicine| <= 20

% Upper bounds (chosen sufficiently large to bound variables)
int: UB = 1000;

% Variables
var 0..UB: nurse;
var 0..UB: doctor;
var 0..UB: equipment;
var 0..UB: medicine;

var 0..(cost_nurse*UB + cost_doctor*UB + cost_equipment*UB + cost_medicine*UB): total_cost;

% Constraints
constraint nurse + doctor >= min_staff;
constraint equipment + medicine <= max_storage;
constraint nurse - equipment >= min_nurse_minus_equipment;
constraint abs(doctor - medicine) <= max_doctor_medicine_diff;

constraint total_cost =
  cost_nurse * nurse + cost_doctor * doctor + cost_equipment * equipment + cost_medicine * medicine;

% Objective
solve minimize total_cost;