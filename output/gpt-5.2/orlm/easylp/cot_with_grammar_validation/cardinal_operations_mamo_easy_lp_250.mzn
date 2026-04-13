% Parameters
int: timeX = 1;
int: timeY = 2;
int: timeZ = 3;

int: c1_X = 2;
int: c1_Y = 1;
int: rhs1 = 6;

int: c2_X = 1;
int: c2_Z = 1;
int: rhs2 = 5;

int: c3_Y = 1;
int: c3_Z = 1;
int: rhs3 = 7;

% Variables
var 0..rhs1: X;
var 0..rhs1: Y;
var 0..rhs3: Z;

var 0..(rhs1 * timeX + rhs3 * timeY + rhs3 * timeZ): totalHours;

% Constraints
constraint (c1_X * X) * timeX + (c1_Y * Y) * timeY <= rhs1;
constraint (c2_X * X) * timeX + (c2_Z * Z) * timeZ <= rhs2;
constraint (c3_Y * Y) * timeY + (c3_Z * Z) * timeZ >= rhs3;

constraint totalHours = X * timeX + Y * timeY + Z * timeZ;

% Objective
solve minimize totalHours;