% Parameters
% Costs per teacher at each school
int: cost_X = 2;
int: cost_Y = 3;
int: cost_Z = 4;
int: cost_W = 5;

% Right-hand sides of the equality constraints
int: rhs1 = 50;    % tX + tY - s1 = 50
int: rhs2 = 100;   % tY + tZ - s2 = 100
int: rhs3 = 20;    % tZ - tW + s3 = 20
int: rhs4 = 30;    % tX - tW + s4 = 30


% Variables
% Number of teachers allocated to each school (non-negative integers)
var 0..1000: tX;  % teachers at school X
var 0..1000: tY;  % teachers at school Y
var 0..1000: tZ;  % teachers at school Z
var 0..1000: tW;  % teachers at school W

% Surplus variables (non-negative integers)
var 0..1000: s1;
var 0..1000: s2;
var 0..1000: s3;
var 0..1000: s4;


% Constraints
%--- Teacher allocation balance constraints (given equalities) ---
constraint tX + tY - s1 = rhs1;   % X + Y - s1 = 50
constraint tY + tZ - s2 = rhs2;   % Y + Z - s2 = 100
constraint tZ - tW + s3 = rhs3;   % Z - W + s3 = 20
constraint tX - tW + s4 = rhs4;   % X - W + s4 = 30


% Objective
solve minimize cost_X * tX + cost_Y * tY + cost_Z * tZ + cost_W * tW;