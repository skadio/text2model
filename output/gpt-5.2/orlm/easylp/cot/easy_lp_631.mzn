% Parameters (with values embedded)
int: f1 = 2;
int: f2 = 3;
int: f3 = 4;
int: f4 = 5;

int: max_x1 = 60;
int: max_x2 = 70;
int: max_x3 = 80;
int: max_x4 = 90;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

var int: total_fatigue;

% Constraints
constraint x1 + x2 <= 100;
constraint x3 + x4 >= 50;

constraint 2 * x1 - x2 = 30;

% (x4/2) - x3 <= 20  ->  x4 - 2*x3 <= 40 (avoids fractional division)
constraint x4 - 2 * x3 <= 40;

constraint total_fatigue = f1*x1 + f2*x2 + f3*x3 + f4*x4;

% Objective
solve minimize total_fatigue;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "minimum_total_fatigue=", show(total_fatigue), "\n"
];