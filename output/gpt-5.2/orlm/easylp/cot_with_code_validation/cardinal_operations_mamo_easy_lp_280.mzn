% Parameters
int: cap = 1000;
int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: revX = 500;
int: revY = 300;
int: revZ = 200;

% Variables
var minX..cap: x;
var minY..cap: y;
var minZ..cap: z;

var 0..(cap * max(revX, max(revY, revZ))): total_revenue;

% Constraints
constraint x + y + z <= cap;

constraint total_revenue = revX * x + revY * y + revZ * z;

% Objective
solve maximize total_revenue;