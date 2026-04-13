% Parameters
int: fatigue1 = 2;
int: fatigue2 = 3;
int: fatigue3 = 4;
int: fatigue4 = 5;

int: max_x1_x2 = 8;
int: min_2x2_x3 = 10;
int: max_x3_3x4_diff = 15;
int: x4_minus_x1_eq = 5;

% Variable bounds (chosen to be safe but finite)
int: UB = 100;

% Variables
var 0..UB: x1;
var 0..UB: x2;
var 0..UB: x3;
var 0..UB: x4;

var 0..(fatigue1*UB + fatigue2*UB + fatigue3*UB + fatigue4*UB): total_fatigue;

% Constraints
constraint x1 + x2 <= max_x1_x2;
constraint 2*x2 + x3 >= min_2x2_x3;
constraint x3 - 3*x4 <= max_x3_3x4_diff;
constraint x4 - x1 = x4_minus_x1_eq;

constraint total_fatigue = fatigue1*x1 + fatigue2*x2 + fatigue3*x3 + fatigue4*x4;

% Objective
solve minimize total_fatigue;