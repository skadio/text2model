% Parameters
int: B = 1000;          % total budget upper bound
int: minX = 200;        % X must exceed 2*Y by at least this amount
int: minZdiff = 100;    % Z must be at least this much more than Y
int: cX = 2;            % cost per unit of X
int: cY = 3;            % cost per unit of Y
int: cZ = 1;            % cost per unit of Z

% Variables
var 0..B: X;
var 0..B: Y;
var 0..B: Z;

var 0..(cX*B + cY*B + cZ*B): total_cost;

% Constraints
constraint X + Y + Z <= B;

constraint X >= 2*Y + minX;
constraint Z >= Y + minZdiff;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;