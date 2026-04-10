% Parameters
int: cost_nurse = 2;          % Cost per nurse
int: cost_doctor = 3;         % Cost per doctor
int: cost_equipment = 4;      % Cost per equipment unit
int: cost_medicine = 5;       % Cost per medicine unit

int: min_staff = 50;          % Minimum nurses + doctors
int: max_storage = 100;       % Maximum equipment + medicine
int: min_nurse_minus_eq = 10; % Minimum (nurses - equipment)
int: max_doc_med_diff = 20;   % Maximum |doctors - medicine|

int: ub_nurse = 1000;         % Upper bound (large, since not explicitly given)
int: ub_doctor = 1000;        % Upper bound (large, since not explicitly given)
int: ub_equipment = 1000;     % Upper bound (large, since not explicitly given)
int: ub_medicine = 1000;      % Upper bound (large, since not explicitly given)

% Variables
var 0..ub_nurse: nurse;           % Number of nurses (integer)
var 0..ub_doctor: doctor;         % Number of doctors (integer)
var 0..ub_equipment: equipment;   % Number of equipment units (integer)
var 0..ub_medicine: medicine;     % Number of medicine units (integer)

var 0..(cost_nurse*ub_nurse + cost_doctor*ub_doctor + cost_equipment*ub_equipment + cost_medicine*ub_medicine): total_cost;
                                  % Total operational cost

% Constraints
% Staffing adequacy: ensure enough total staff
constraint nurse + doctor >= min_staff;

% Storage/space limitation: cap total stored items
constraint equipment + medicine <= max_storage;

% Utilization requirement: keep nurses sufficiently above equipment count
constraint nurse - equipment >= min_nurse_minus_eq;

% Balance requirement: doctors and medicine should not differ too much
constraint abs(doctor - medicine) <= max_doc_med_diff;

% Total cost definition (linking variable to decision variables)
constraint total_cost =
    cost_nurse * nurse
  + cost_doctor * doctor
  + cost_equipment * equipment
  + cost_medicine * medicine;

% Objective
solve minimize total_cost;