% Parameters
int: B = 1000;
int: min_diff_XY = 200;      % 2*X - Y >= 200
int: max_diff_YZ = 50;       % |Y - Z| <= 50

int: cX = 10;
int: cY = 20;
int: cZ = 30;

int: LBX = 0; int: UBX = B;
int: LBY = 0; int: UBY = B;
int: LBZ = 0; int: UBZ = B;

% Variables
var LBX..UBX: X;
var LBY..UBY: Y;
var LBZ..UBZ: Z;

var 0..(cX*UBX + cY*UBY + cZ*UBZ): total_cost;

% Constraints
constraint X + Y + Z <= B;

constraint 2*X - Y >= min_diff_XY;

constraint abs(Y - Z) <= max_diff_YZ;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;