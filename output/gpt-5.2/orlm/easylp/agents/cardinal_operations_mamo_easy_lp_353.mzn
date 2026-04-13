% Parameters
% Unit costs
int: cost_nurse = 2;
int: cost_doctor = 3;
int: cost_equipment = 4;
int: cost_medicine = 5;

% Requirement/limit constants
int: min_staff = 50;                 % nurse + doctor >= 50
int: max_storage = 100;              % equipment + medicine <= 100
int: min_nurse_over_equipment = 10;  % nurse >= equipment + 10
int: max_doc_med_diff = 20;          % |doctor - medicine| <= 20

% Upper limits (safe finite bounds)
int: ub_nurse = 200;
int: ub_doctor = 200;
int: ub_equipment = max_storage;     % implied by equipment+medicine<=100 and nonnegativity
int: ub_medicine = max_storage;      % implied by equipment+medicine<=100 and nonnegativity


% Variables
var 0..ub_nurse: nurse;           % number of nurses
var 0..ub_doctor: doctor;         % number of doctors
var 0..ub_equipment: equipment;   % units of medical equipment
var 0..ub_medicine: medicine;     % units of medicine supplies

var int: total_cost;              % total operational cost (objective value)


% Constraints
% Staffing adequacy: ensure enough combined nurses and doctors
constraint nurse + doctor >= min_staff;

% Storage/space limitation: total equipment and medicine cannot exceed capacity
constraint equipment + medicine <= max_storage;

% Utilization policy: keep at least 10 more nurses than equipment units
constraint nurse >= equipment + min_nurse_over_equipment;

% Balance constraint: doctors and medicine levels must stay within allowed difference
constraint abs(doctor - medicine) <= max_doc_med_diff;

% Total cost definition
constraint total_cost =
  cost_nurse * nurse +
  cost_doctor * doctor +
  cost_equipment * equipment +
  cost_medicine * medicine;


% Objective
solve minimize total_cost;