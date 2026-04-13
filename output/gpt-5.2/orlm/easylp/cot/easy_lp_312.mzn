% Parameters (with values embedded)
int: TOTAL_MAX = 1000;
int: YZ_MAX = 800;
int: X_OFFSET = 200;

int: costX = 500;
int: costY = 700;
int: costZ = 300;

% Variables
var 0..TOTAL_MAX: X;
var 0..TOTAL_MAX: Y;
var 0..TOTAL_MAX: Z;

% Constraints
constraint X + Y + Z <= TOTAL_MAX;
constraint X >= 2 * Y + X_OFFSET;
constraint Y + Z <= YZ_MAX;

% Objective
solve minimize costX * X + costY * Y + costZ * Z;