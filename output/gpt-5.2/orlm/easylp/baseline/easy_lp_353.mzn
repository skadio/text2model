% Hospital resource allocation - minimize total cost

% Costs
int: cost_nurse = 2;
int: cost_doctor = 3;
int: cost_equipment = 4;
int: cost_medicine = 5;

% Upper limits (not specified in the description; use safe, derived bounds)
% Since equipment + medicine <= 100, each is <= 100.
% Nurses/doctors need at least 50 combined; choose reasonable caps to keep search bounded.
int: max_nurse = 200;
int: max_doctor = 200;
int: max_equipment = 100;
int: max_medicine = 100;

% Decision variables (all whole numbers)
var 0..max_nurse: nurse;
var 0..max_doctor: doctor;
var 0..max_equipment: equipment;
var 0..max_medicine: medicine;

% Constraints
constraint nurse + doctor >= 50;
constraint equipment + medicine <= 100;
constraint nurse >= equipment + 10;
constraint abs(doctor - medicine) <= 20;

% Objective
var int: total_cost = cost_nurse * nurse
                    + cost_doctor * doctor
                    + cost_equipment * equipment
                    + cost_medicine * medicine;

solve minimize total_cost;

output [
  "nurse=", show(nurse), "\n",
  "doctor=", show(doctor), "\n",
  "equipment=", show(equipment), "\n",
  "medicine=", show(medicine), "\n",
  "total_cost=", show(total_cost), "\n"
];