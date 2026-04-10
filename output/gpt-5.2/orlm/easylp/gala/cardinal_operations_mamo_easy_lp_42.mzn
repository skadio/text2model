include "globals.mzn";

% Data (embedded as required)
int: doc_patients = 2;
int: nurse_patients = 3;
int: min_patients = 10;

int: max_staff = 12;

int: doc_cost = 5;
int: nurse_cost = 3;

% Decision variables: number of doctors and nurses (whole numbers)
var 0..max_staff: doctors;
var 0..max_staff: nurses;

% Constraints
constraint doctors + nurses <= max_staff;
constraint doc_patients * doctors + nurse_patients * nurses >= min_patients;

% Objective: minimize total cost
var int: total_cost = doc_cost * doctors + nurse_cost * nurses;
solve minimize total_cost;

output [
  "doctors = ", show(doctors), "\n",
  "nurses = ", show(nurses), "\n",
  "total_cost = ", show(total_cost), "\n"
];