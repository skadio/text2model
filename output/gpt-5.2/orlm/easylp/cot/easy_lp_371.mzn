% Parameters (with values embedded)
int: wN1 = 3;
int: wN2 = 2;
int: wD1 = 4;
int: wD2 = 5;

int: minNurses = 10;
int: minDoctors = 8;
int: maxDiffN1D1 = 4;
int: maxDiffN2D2 = 3;

% Variables
var 0..100: Nurse1;
var 0..100: Nurse2;
var 0..100: Doctor1;
var 0..100: Doctor2;

var 0..10000: total_workload;

% Constraints
constraint Nurse1 + Nurse2 >= minNurses;
constraint Doctor1 + Doctor2 >= minDoctors;

constraint abs(Nurse1 - Doctor1) <= maxDiffN1D1;
constraint abs(Nurse2 - Doctor2) <= maxDiffN2D2;

constraint total_workload = wN1*Nurse1 + wN2*Nurse2 + wD1*Doctor1 + wD2*Doctor2;

% Objective
solve minimize total_workload;