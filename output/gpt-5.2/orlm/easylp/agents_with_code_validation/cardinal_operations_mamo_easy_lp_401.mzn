% Parameters
% Maximum available units for each type
int: maxX1 = 200;
int: maxX2 = 150;
int: maxX3 = 120;
int: maxX4 = 90;

% Cost per unit (supply points)
int: costX1 = 5000;
int: costX2 = 4000;
int: costX3 = 6000;
int: costX4 = 7000;


% Variables
% Decision variables: allocated whole units for each type (bounded by availability)
var 0..maxX1: X1;
var 0..maxX2: X2;
var 0..maxX3: X3;
var 0..maxX4: X4;

% Total cost (bounded by maximum possible spend)
var 0..(costX1*maxX1 + costX2*maxX2 + costX3*maxX3 + costX4*maxX4): total_cost;


% Constraints
% --- Total-cost definition (linking constraint) ---
constraint
  total_cost = costX1*X1 + costX2*X2 + costX3*X3 + costX4*X4;

% --- Strategic/logistical allocation constraints ---
% Combined units of X1 and X2 must be at least 100
constraint
  X1 + X2 >= 100;

% Logistics limit on X2 and X3
constraint
  2*X2 + 3*X3 <= 250;

% X4 must exceed X1 by at least 50
constraint
  X4 - X1 >= 50;

% Relation between X3 and X4
constraint
  X3 - 2*X4 <= -30;


% Objective
solve minimize total_cost;