% Weekly training schedule optimization (all data embedded)

var 0..100: X; % strength hours
var 0..100: Y; % endurance hours
var 0..100: Z; % agility hours

int: fatigue_X = 6;
int: fatigue_Y = 3;
int: fatigue_Z = 5;

% Constraints
constraint X + Y >= 8;
constraint X + Z <= 10;
constraint Y - Z >= 2;

% Objective: minimize total fatigue
var int: total_fatigue = fatigue_X * X + fatigue_Y * Y + fatigue_Z * Z;

solve minimize total_fatigue;

output [
  "X (strength hours) = ", show(X), "\n",
  "Y (endurance hours) = ", show(Y), "\n",
  "Z (agility hours) = ", show(Z), "\n",
  "Minimum total fatigue = ", show(total_fatigue), "\n"
];