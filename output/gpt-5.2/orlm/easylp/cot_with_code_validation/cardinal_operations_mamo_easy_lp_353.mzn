% Parameters
int: cost_nurse = 2;
int: cost_doctor = 3;
int: cost_equipment = 4;
int: cost_medicine = 5;

int: min_staff = 50;              % nurse + doctor >= 50
int: max_storage = 100;           % equipment + medicine <= 100
int: min_nurse_minus_equipment = 10; % nurse - equipment >= 10
int: max_doctor_medicine_diff = 20;  % |doctor - medicine| <= 20

int: staff_upper_bound = 200;     % safe upper bound for nurse, doctor
int: storage_upper_bound = 100;   % from equipment + medicine <= 100

% Variables
var 0..staff_upper_bound: nurse;
var 0..staff_upper_bound: doctor;
var 0..storage_upper_bound: equipment;
var 0..storage_upper_bound: medicine;

var int: total_cost;

% Constraints
constraint nurse + doctor >= min_staff;

constraint equipment + medicine <= max_storage;

constraint nurse - equipment >= min_nurse_minus_equipment;

constraint abs(doctor - medicine) <= max_doctor_medicine_diff;

constraint total_cost =
  cost_nurse * nurse +
  cost_doctor * doctor +
  cost_equipment * equipment +
  cost_medicine * medicine;

% Objective
solve minimize total_cost;