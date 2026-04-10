% Parameters
% Cost coefficients for projects X1..X4
int: c1 = 4;
int: c2 = 2;
int: c3 = 3;
int: c4 = 5;

% Constraint constants
int: diff12_max = 100;     % |0.5*X2 - X1| <= 100
int: gap13_min  = 200;     % X1 >= 200 + 0.7*X3
int: diff42_max = 150;     % |X4 - 0.6*X2| <= 150
int: diff31_max = 300;     % |0.8*X3 - X1| <= 300
int: gap42_min  = 50;      % X4 >= X2 + 50

% Minimum allocation (nonnegative whole-number resources)
int: X_min = 0;

% Variables
var int: X1; % resources allocated to project X1 (tree planting)
var int: X2; % resources allocated to project X2 (waste management)
var int: X3; % resources allocated to project X3 (water conservation)
var int: X4; % resources allocated to project X4 (renewable energy)

% Constraints
% Enforce nonnegativity (whole-number allocations)
constraint X1 >= X_min;
constraint X2 >= X_min;
constraint X3 >= X_min;
constraint X4 >= X_min;

% --- Difference constraint between 0.5*X2 and X1: |0.5*X2 - X1| <= 100 ---
% Multiply by 2 to avoid fractional coefficients: |X2 - 2*X1| <= 200
constraint
  abs(X2 - 2 * X1) <= 2 * diff12_max;

% --- Lower bound linking X1 and X3: X1 >= 200 + 0.7*X3 ---
% Multiply by 10 to avoid decimals: 10*X1 >= 10*200 + 7*X3
constraint
  10 * X1 >= 10 * gap13_min + 7 * X3;

% --- Difference constraint between X4 and 0.6*X2: |X4 - 0.6*X2| <= 150 ---
% Multiply by 10 to avoid decimals: |10*X4 - 6*X2| <= 1500
constraint
  abs(10 * X4 - 6 * X2) <= 10 * diff42_max;

% --- Difference constraint between 0.8*X3 and X1: |0.8*X3 - X1| <= 300 ---
% Multiply by 10 to avoid decimals: |8*X3 - 10*X1| <= 3000
constraint
  abs(8 * X3 - 10 * X1) <= 10 * diff31_max;

% --- Minimum gap between X4 and X2: X4 >= X2 + 50 ---
constraint
  X4 >= X2 + gap42_min;

% Objective
solve minimize c1 * X1 + c2 * X2 + c3 * X3 + c4 * X4;