% Parameters (with values embedded)
int: fatigue1 = 10;
int: fatigue2 = 15;
int: fatigue3 = 20;
int: fatigue4 = 25;

int: max12 = 12;
int: max34 = 16;
int: min13 = 8;
int: min24 = 10;

% Variables
var 0..12: x1;
var 0..12: x2;
var 0..16: x3;
var 0..16: x4;

var 0..(fatigue1*12 + fatigue2*12 + fatigue3*16 + fatigue4*16): total_fatigue;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;
constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

constraint total_fatigue = fatigue1*x1 + fatigue2*x2 + fatigue3*x3 + fatigue4*x4;

% Objective
solve minimize total_fatigue;