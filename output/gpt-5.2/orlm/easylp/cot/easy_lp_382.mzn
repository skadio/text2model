% Parameters (with values embedded)
int: fatigue_X = 2;
int: fatigue_Y = 3;
int: fatigue_Z = 4;
int: fatigue_W = 5;

int: X_min = 0; int: X_max = 5;
int: Y_min = 0; int: Y_max = 5;
int: Z_min = 0; int: Z_max = 6;
int: W_min = 0; int: W_max = 6;

% Variables
var X_min..X_max: X;
var Y_min..Y_max: Y;
var Z_min..Z_max: Z;
var W_min..W_max: W;

var 0..(fatigue_X*X_max + fatigue_Y*Y_max + fatigue_Z*Z_max + fatigue_W*W_max): total_fatigue;

% Constraints
constraint X + Y <= 10;
constraint Z + W <= 12;
constraint X + Z >= 6;
constraint Y + W >= 8;

constraint total_fatigue = fatigue_X*X + fatigue_Y*Y + fatigue_Z*Z + fatigue_W*W;

% Objective
solve minimize total_fatigue;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " W=", show(W), "\n",
  "minimum_total_fatigue=", show(total_fatigue), "\n"
];