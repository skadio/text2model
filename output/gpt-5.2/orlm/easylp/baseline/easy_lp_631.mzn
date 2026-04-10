% Sports training allocation - minimize total fatigue score

int: max_x1 = 60;
int: max_x2 = 70;
int: max_x3 = 80;
int: max_x4 = 90;

var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

% Constraints
constraint x1 + x2 <= 100;
constraint x3 + x4 >= 50;
constraint 2*x1 - x2 = 30;

% (x4/2 - x3) <= 20  ->  x4 - 2*x3 <= 40
constraint x4 - 2*x3 <= 40;

% Objective: minimize total fatigue score
var int: total_fatigue = 2*x1 + 3*x2 + 4*x3 + 5*x4;
solve minimize total_fatigue;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "minimum_total_fatigue=", show(total_fatigue), "\n"
];