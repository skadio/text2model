% Parameters
int: doctor_patients = 2;
int: nurse_patients = 3;
int: min_patients = 10;

int: max_staff = 12;

int: doctor_cost = 5;
int: nurse_cost = 3;

% Variables
var 0..max_staff: doctors;
var 0..max_staff: nurses;

var 0..(doctor_cost*max_staff + nurse_cost*max_staff): total_cost;

% Constraints
constraint doctors + nurses <= max_staff;

constraint doctor_patients * doctors + nurse_patients * nurses >= min_patients;

constraint total_cost = doctor_cost * doctors + nurse_cost * nurses;

% Objective
solve minimize total_cost;