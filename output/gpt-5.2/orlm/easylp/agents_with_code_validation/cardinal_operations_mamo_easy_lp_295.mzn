% Parameters
% Per-teacher costs (units)
int: costX = 4;        % Math (X)
int: costY = 3;        % Science (Y)
int: costZ = 2;        % Arts (Z)

% Allocation limits/requirements
int: maxXY = 25;       % Upper bound on X + Y
int: minXZ = 15;       % Lower bound on X + Z
int: maxYZ = 20;       % Upper bound on Y + Z

% Variables
% Number of teachers in each department (non-negative integers)
var 0..maxXY: X;       % Math teachers
var 0..maxXY: Y;       % Science teachers
var 0..maxYZ: Z;       % Arts teachers

% Total cost (bounded by worst-case within declared variable ranges)
var 0..(costX*maxXY + costY*maxXY + costZ*maxYZ): totalCost;

% Constraints
% --- Department allocation limits ---
constraint X + Y <= maxXY;
constraint X + Z >= minXZ;
constraint Y + Z <= maxYZ;

% --- Total cost definition ---
constraint totalCost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize totalCost;