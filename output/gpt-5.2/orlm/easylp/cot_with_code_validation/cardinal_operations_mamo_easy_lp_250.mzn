% Parameters
int: time_X = 1;
int: time_Y = 2;
int: time_Z = 3;

int: c1_X = 2;  % coefficient for X in constraint 1
int: c1_Y = 1;  % coefficient for Y in constraint 1
int: c1_rhs = 6;

int: c2_X = 1;  % coefficient for X in constraint 2
int: c2_Z = 1;  % coefficient for Z in constraint 2
int: c2_rhs = 5;

int: c3_Y = 1;  % coefficient for Y in constraint 3 (in hours)
int: c3_Z = 1;  % coefficient for Z in constraint 3 (in hours)
int: c3_rhs = 7;

% Derived safe upper bounds
int: maxX = c2_rhs;                          % from X + Z <= 5 with Z >= 0
int: maxY = c1_rhs div time_Y;               % from 2X + Y <= 6 implies Y <= 6, hours => Y tasks <= 3
int: maxZ = c2_rhs;                          % from X + Z <= 5 with X >= 0

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

var 0..(time_X*maxX + time_Y*maxY + time_Z*maxZ): total_hours;

% Constraints
constraint c1_X * time_X * X + c1_Y * time_Y * Y <= c1_rhs;
constraint c2_X * X + c2_Z * Z <= c2_rhs;
constraint c3_Y * time_Y * Y + c3_Z * time_Z * Z >= c3_rhs;

constraint total_hours = time_X * X + time_Y * Y + time_Z * Z;

% Objective
solve minimize total_hours;