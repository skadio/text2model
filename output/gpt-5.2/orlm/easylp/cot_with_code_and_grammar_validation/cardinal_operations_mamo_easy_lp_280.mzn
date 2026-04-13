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

var 0..(revX*CAP + revY*CAP + revZ*CAP): totalRevenue;

% Constraints
constraint x + y + z <= CAP;

constraint totalRevenue = revX*x + revY*y + revZ*z;

% Objective
solve maximize totalRevenue;