% Parameters
% Maximum hours allowed for each task (given in the problem statement)
int: maxX1 = 10;
int: maxX2 = 15;
int: maxX3 = 20;
int: maxX4 = 25;

% Pairwise duration constraints (given)
int: maxX1X2 = 8;     % X1 + X2 <= 8
int: maxX2X3 = 12;    % X2 + X3 <= 12
int: minX3X4 = 14;    % X3 + X4 >= 14

% Costs per hour for each task (given)
int: costX1 = 10;
int: costX2 = 20;
int: costX3 = 30;
int: costX4 = 40;


% Variables
% Whole number of hours allocated to each task (non-negative and bounded)
var 0..maxX1: X1;   % hours for task X1
var 0..maxX2: X2;   % hours for task X2
var 0..maxX3: X3;   % hours for task X3
var 0..maxX4: X4;   % hours for task X4

% Total cost (bounded using max possible given variable upper bounds)
var 0..(costX1*maxX1 + costX2*maxX2 + costX3*maxX3 + costX4*maxX4): totalCost;


% Constraints
% --- Total cost definition (sum of hourly costs * allocated hours) ---
constraint
  totalCost = costX1 * X1 + costX2 * X2 + costX3 * X3 + costX4 * X4;

% --- Pairwise duration (interdependency) constraints ---
constraint
  X1 + X2 <= maxX1X2;          % Combined duration of X1 and X2 cannot exceed 8

constraint
  X2 + X3 <= maxX2X3;          % Combined duration of X2 and X3 cannot exceed 12

constraint
  X3 + X4 >= minX3X4;          % Combined duration of X3 and X4 must be at least 14

% --- Balance/relationship constraints between tasks ---
constraint
  2 * X2 - X1 - X3 <= -6;      % Twice X2 minus X1 and X3 should not surpass -6

% Convert "X3 - (1/2)X4 >= X2" into an integer-safe form (avoid fractional coercion)
constraint
  2 * X3 - X4 >= 2 * X2;       % Equivalent to: X3 - X4/2 >= X2


% Objective
solve minimize totalCost;