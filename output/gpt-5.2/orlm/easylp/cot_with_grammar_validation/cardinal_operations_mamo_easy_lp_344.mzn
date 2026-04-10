% Parameters
int: max12 = 1000;
int: max34 = 500;

int: min_return12 = 50;          % 0.05*X1 + 0.07*X2 >= 50
int: min_loss34 = -20;           % -0.03*X3 - 0.04*X4 <= -20

int: c1 = 10;
int: c2 = 15;
int: c3 = 20;
int: c4 = 25;

% scaled (x100) to avoid decimals
int: r1 = 5;     % 0.05
int: r2 = 7;     % 0.07
int: l3 = -3;    % -0.03
int: l4 = -4;    % -0.04

int: scale = 100;

% Variables
var 0..max12: X1;
var 0..max12: X2;
var 0..max34: X3;
var 0..max34: X4;

var 0..(c1*max12 + c2*max12 + c3*max34 + c4*max34): total_cost;

% Constraints
constraint X1 + X2 <= max12;
constraint r1*X1 + r2*X2 >= min_return12 * scale;

constraint X3 + X4 <= max34;
constraint l3*X3 + l4*X4 <= min_loss34 * scale;

constraint total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

% Objective
solve minimize total_cost;