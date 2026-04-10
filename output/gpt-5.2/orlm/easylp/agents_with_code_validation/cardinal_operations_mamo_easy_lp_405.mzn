% Parameters
% Revenue/cost rates per unit for each ship load x1..x4
int: c1 = 4;
int: c2 = 3;
int: c3 = 5;
int: c4 = 6;

% Capacity limits
int: cap12 = 1000;   % x1 + x2 <= 1000
int: cap34 = 800;    % x3 + x4 <= 800

% Contract requirement thresholds
int: req12 = 300;    % (1/2)x1 + (1/4)x2 >= 300
int: req34 = 250;    % (3/4)x3 + (3/5)x4 >= 250


% Variables
% Integer ship loads (whole-number cargo units)
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;


% Constraints
% --- Capacity constraints (port/operating limits) ---
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% --- Contract requirement constraints (avoid fractional coefficients via scaling) ---
% (1/2)x1 + (1/4)x2 >= req12  <=>  2*x1 + x2 >= 4*req12
constraint 2 * x1 + x2 >= 4 * req12;

% (3/4)x3 + (3/5)x4 >= req34  <=>  15*x3 + 12*x4 >= 20*req34
constraint 15 * x3 + 12 * x4 >= 20 * req34;


% Objective
solve minimize c1*x1 + c2*x2 + c3*x3 + c4*x4;