% Parameters (with values embedded)
int: n = 4;
set of int: G = 1..n;

array[G] of int: fatigue = [5, 4, 3, 6]; % per-hour fatigue for X1..X4

int: maxX1X2 = 15;
int: minX2X3 = 10;
int: maxDiffX3X4 = 8;

% Variables
var 0..15: X1;   % strength conditioning
var 0..15: X2;   % skill development
var 0..15: X3;   % strategy and tactics
var 0..15: X4;   % recovery

var 0..(6*15 + 5*15 + 4*15 + 3*15): total_fatigue;

% Constraints
constraint X1 + X2 <= maxX1X2;
constraint X2 + X3 >= minX2X3;
constraint abs(X3 - X4) <= maxDiffX3X4;
constraint X1 >= 2*X4 + 5;

constraint total_fatigue = 5*X1 + 4*X2 + 3*X3 + 6*X4;

% Objective
solve minimize total_fatigue;

output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), " X4=", show(X4), "\n",
  "Minimum total fatigue score (rounded) = ", show(total_fatigue), "\n"
];