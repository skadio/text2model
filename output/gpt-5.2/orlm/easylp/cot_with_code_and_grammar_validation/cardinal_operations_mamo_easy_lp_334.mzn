% Parameters
int: max_XY = 5000;
int: max_ZW = 2000;

int: diff_XZ = 1000;
int: diff_YW = 1500;

int: ub_X = 4000;
int: ub_Y = 3000;
int: lb_Z = 500;
int: lb_W = 200;

int: cX = 20;
int: cY = 30;
int: cZ = 50;
int: cW = 10;

% Variables
var 0..ub_X: X;
var 0..ub_Y: Y;
var lb_Z..2000: Z;
var lb_W..2000: W;

var int: total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint Z + W <= max_ZW;

constraint X - Z >= diff_XZ;
constraint Y - W >= diff_YW;

constraint total_cost = cX * X + cY * Y + cZ * Z + cW * W;

% Objective
solve minimize total_cost;