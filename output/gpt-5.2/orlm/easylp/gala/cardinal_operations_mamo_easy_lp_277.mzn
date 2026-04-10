% Weekly training schedule optimization (all data embedded)

include "globals.mzn";

% Decision variables: weekly hours (whole numbers)
var 0..100: X; % strength
var 0..100: Y; % endurance
var 0..100: Z; % agility

% Fatigue per hour
int: fx = 6;
int: fy = 3;
int: fz = 5;

% Constraints
constraint X + Y >= 8;
constraint X + Z <= 10;
constraint Y - Z >= 2;

% Objective: minimize total fatigue
var int: total_fatigue = fx * X + fy * Y + fz * Z;

solve minimize total_fatigue;

output [
  "X(strength) = ", show(X), "\n",
  "Y(endurance) = ", show(Y), "\n",
  "Z(agility) = ", show(Z), "\n",
  "Minimum total fatigue (rounded) = ", show(total_fatigue), "\n"
];