% Parameters
int: fatigue_X = 2;
int: fatigue_Y = 3;
int: fatigue_Z = 4;
int: fatigue_W = 5;

int: max_XY = 10;
int: max_ZW = 12;
int: min_XZ = 6;
int: min_YW = 8;

int: lb_X = 0; int: ub_X = 5;
int: lb_Y = 0; int: ub_Y = 5;
int: lb_Z = 0; int: ub_Z = 6;
int: lb_W = 0; int: ub_W = 6;

% Variables
var lb_X..ub_X: X;
var lb_Y..ub_Y: Y;
var lb_Z..ub_Z: Z;
var lb_W..ub_W: W;

var 0..(fatigue_X*ub_X + fatigue_Y*ub_Y + fatigue_Z*ub_Z + fatigue_W*ub_W): total_fatigue;

% Constraints
constraint X + Y <= max_XY;
constraint Z + W <= max_ZW;

constraint X + Z >= min_XZ;
constraint Y + W >= min_YW;

constraint total_fatigue = fatigue_X*X + fatigue_Y*Y + fatigue_Z*Z + fatigue_W*W;

% Objective
solve minimize total_fatigue;