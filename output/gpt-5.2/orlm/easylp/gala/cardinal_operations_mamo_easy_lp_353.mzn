include "globals.mzn";

% Costs (units per resource)
int: cost_nurse     = 2;
int: cost_doctor    = 3;
int: cost_equipment = 4;
int: cost_medicine  = 5;

% Requirements / limits (from problem statement)
int: min_staff = 50;          % nurse + doctor >= 50
int: max_storage = 100;       % equipment + medicine <= 100
int: min_nurse_minus_eq = 10; % nurse >= equipment + 10
int: max_doc_med_diff = 20;   % |doctor - medicine| <= 20

% Upper bounds (not numerically specified in the statement).
% To keep the model bounded and runnable, we use safe implied bounds:
% - From nurse >= equipment+10 and equipment+medicine <= 100 => nurse <= 110
% - doctor + nurse >= 50 and nonnegativity => doctor <= 50.. can be larger, but
%   to minimize cost it won't exceed what is needed; we cap at 200 safely.
% - equipment, medicine are bounded by storage 100.
int: UB_nurse = 110;
int: UB_doctor = 200;
int: UB_equipment = 100;
int: UB_medicine = 100;

% Decision variables (integers / whole numbers)
var 0..UB_nurse: nurse;
var 0..UB_doctor: doctor;
var 0..UB_equipment: equipment;
var 0..UB_medicine: medicine;

% Constraints
constraint nurse + doctor >= min_staff;
constraint equipment + medicine <= max_storage;
constraint nurse >= equipment + min_nurse_minus_eq;
constraint abs(doctor - medicine) <= max_doc_med_diff;

% Objective: minimize total cost
var int: total_cost =
  cost_nurse * nurse +
  cost_doctor * doctor +
  cost_equipment * equipment +
  cost_medicine * medicine;

solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "nurse = ", show(nurse), "\n",
  "doctor = ", show(doctor), "\n",
  "equipment = ", show(equipment), "\n",
  "medicine = ", show(medicine), "\n"
];