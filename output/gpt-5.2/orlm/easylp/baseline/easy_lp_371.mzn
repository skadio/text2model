% Hospital staff scheduling - minimize total workload score

var 0..100: Nurse1;
var 0..100: Nurse2;
var 0..100: Doctor1;
var 0..100: Doctor2;

% Workload scores per hour
int: wN1 = 3;
int: wN2 = 2;
int: wD1 = 4;
int: wD2 = 5;

constraint Nurse1 + Nurse2 >= 10;
constraint Doctor1 + Doctor2 >= 8;

constraint abs(Nurse1 - Doctor1) <= 4;
constraint abs(Nurse2 - Doctor2) <= 3;

var int: total_workload = wN1*Nurse1 + wN2*Nurse2 + wD1*Doctor1 + wD2*Doctor2;

solve minimize total_workload;

output [
  "Nurse1=", show(Nurse1), "\n",
  "Nurse2=", show(Nurse2), "\n",
  "Doctor1=", show(Doctor1), "\n",
  "Doctor2=", show(Doctor2), "\n",
  "TotalWorkload=", show(total_workload), "\n"
];