% Parameters
int: max_hours = 15;

int: f1 = 5;
int: f2 = 4;
int: f3 = 3;
int: f4 = 6;

% Variables
var 0..max_hours: x1; % strength conditioning hours
var 0..max_hours: x2; % skill development hours
var 0..max_hours: x3; % strategy and tactics hours
var 0..max_hours: x4; % recovery hours

var 0..(max_hours * (f1 + f2 + f3 + f4)): total_fatigue;

% Constraints
constraint x1 + x2 <= 15;
constraint x2 + x3 >= 10;
constraint abs(x3 - x4) <= 8;
constraint x1 >= 2 * x4 + 5;

constraint total_fatigue = f1 * x1 + f2 * x2 + f3 * x3 + f4 * x4;

% Objective
solve minimize total_fatigue;