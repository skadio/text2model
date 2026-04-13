% Parameters
int: fatigue_x1 = 2;
int: fatigue_x2 = 3;
int: fatigue_x3 = 4;
int: fatigue_x4 = 5;

int: cap_x1 = 60;
int: cap_x2 = 70;
int: cap_x3 = 80;
int: cap_x4 = 90;

int: max_x1x2 = 100;
int: min_x3x4 = 50;

int: eq_rhs = 30;
int: diff_limit = 20;

% Variables
var 0..cap_x1: x1;
var 0..cap_x2: x2;
var 0..cap_x3: x3;
var 0..cap_x4: x4;

var 0..(fatigue_x1*cap_x1 + fatigue_x2*cap_x2 + fatigue_x3*cap_x3 + fatigue_x4*cap_x4): total_fatigue;

% Constraints
constraint x1 + x2 <= max_x1x2;
constraint x3 + x4 >= min_x3x4;
constraint 2*x1 - x2 = eq_rhs;

% (x4/2) - x3 <= 20  ==>  x4 - 2*x3 <= 40
constraint x4 - 2*x3 <= 2*diff_limit;

constraint total_fatigue = fatigue_x1*x1 + fatigue_x2*x2 + fatigue_x3*x3 + fatigue_x4*x4;

% Objective
solve minimize total_fatigue;