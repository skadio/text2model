% Parameters
int: fatigue_x1 = 1000;
int: fatigue_x2 = 1500;
int: fatigue_x3 = 2000;
int: fatigue_x4 = 2500;

int: max_x1_x2 = 20;
int: max_x3_x4 = 15;
int: min_x1_x3 = 10;
int: min_x2_x4 = 8;

% Variables
var 0..max_x1_x2: x1;
var 0..max_x1_x2: x2;
var 0..max_x3_x4: x3;
var 0..max_x3_x4: x4;

var int: total_fatigue;

% Constraints
constraint x1 + x2 <= max_x1_x2;
constraint x3 + x4 <= max_x3_x4;

constraint x1 + x3 >= min_x1_x3;
constraint x2 + x4 >= min_x2_x4;

constraint total_fatigue =
  fatigue_x1 * x1 + fatigue_x2 * x2 + fatigue_x3 * x3 + fatigue_x4 * x4;

% Objective
solve minimize total_fatigue;