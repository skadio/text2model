% Parameters
int: total_space = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: revX = 5;
int: revY = 3;
int: revZ = 2;

% Variables
var minX..total_space: x;
var minY..total_space: y;
var minZ..total_space: z;

var 0..(revX*total_space + revY*total_space + revZ*total_space): total_cost;

% Constraints
constraint x + y + z <= total_space;

constraint total_cost = revX * x + revY * y + revZ * z;

% Objective
solve minimize total_cost;