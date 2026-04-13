% Parameters (with values embedded)
int: capacity = 1000;
int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: revX = 500;
int: revY = 300;
int: revZ = 200;

% Variables
var minX..capacity: X;
var minY..capacity: Y;
var minZ..capacity: Z;

var 0..(revX*capacity + revY*capacity + revZ*capacity): total_revenue;

% Constraints
constraint X + Y + Z <= capacity;

constraint total_revenue = revX * X + revY * Y + revZ * Z;

% Objective
solve maximize total_revenue;