% Parameters
int: costX = 2;
int: costY = 3;
int: costZ = 4;
int: costW = 5;

int: rhs1 = 50;
int: rhs2 = 100;
int: rhs3 = 20;
int: rhs4 = 30;

% Variables
var 0..1000: x;   % teachers at school X
var 0..1000: y;   % teachers at school Y
var 0..1000: z;   % teachers at school Z
var 0..1000: w;   % teachers at school W

var 0..1000: s1;  % surplus 1
var 0..1000: s2;  % surplus 2
var 0..1000: s3;  % surplus 3
var 0..1000: s4;  % surplus 4

% Constraints
constraint x + y - s1 = rhs1;
constraint y + z - s2 = rhs2;
constraint z - w + s3 = rhs3;
constraint x - w + s4 = rhs4;

% Objective
var 0..20000: total_cost;
constraint total_cost = costX*x + costY*y + costZ*z + costW*w;

solve minimize total_cost;