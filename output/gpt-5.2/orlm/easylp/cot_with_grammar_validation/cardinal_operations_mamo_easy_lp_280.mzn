% Parameters
int: CAP = 1000;
int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: revX = 500;
int: revY = 300;
int: revZ = 200;

% Variables
var minX..CAP: x;
var minY..CAP: y;
var minZ..CAP: z;

var 0..(CAP * max([revX, revY, revZ])): total_revenue;

% Constraints
constraint x + y + z <= CAP;

constraint total_revenue = revX * x + revY * y + revZ * z;

% Objective
solve maximize total_revenue;