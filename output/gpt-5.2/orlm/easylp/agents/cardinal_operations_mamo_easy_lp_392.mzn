% Parameters
% Teacher costs per school (units per teacher)
int: costX = 2;
int: costY = 3;
int: costZ = 4;
int: costW = 5;

% Right-hand sides of the balance constraints
int: rhs1 = 50;   % X + Y - s1 = 50
int: rhs2 = 100;  % Y + Z - s2 = 100
int: rhs3 = 20;   % Z - W + s3 = 20
int: rhs4 = 30;   % X - W + s4 = 30;


% Variables
% Number of teachers allocated to each school (nonnegative integers)
var 0..1000: tX;  % teachers at school X
var 0..1000: tY;  % teachers at school Y
var 0..1000: tZ;  % teachers at school Z
var 0..1000: tW;  % teachers at school W

% Surplus variables (nonnegative integers)
var 0..1000: s1;
var 0..1000: s2;
var 0..1000: s3;
var 0..1000: s4;


% Constraints
% Balance constraints (equalities)
constraint tX + tY - s1 = rhs1;   % X + Y - s1 = 50
constraint tY + tZ - s2 = rhs2;   % Y + Z - s2 = 100
constraint tZ - tW + s3 = rhs3;   % Z - W + s3 = 20
constraint tX - tW + s4 = rhs4;   % X - W + s4 = 30

% Nonnegativity is enforced by variable domains (0..1000)


% Objective
solve minimize costX * tX + costY * tY + costZ * tZ + costW * tW;