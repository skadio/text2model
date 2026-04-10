% Training schedule optimization (embedded data)

int: fatigueX = 10;
int: fatigueY = 15;
int: fatigueZ = 5;

% Decision variables: whole number of hours
var 0..100: X; % strength conditioning
var 0..100: Y; % skill development
var 0..100: Z; % strategy & tactics

% Constraints
constraint X + Y >= 8;
constraint Y + Z <= 20;
constraint X >= Z + 3;

% Objective: minimize total fatigue score
var int: total_fatigue = fatigueX * X + fatigueY * Y + fatigueZ * Z;
solve minimize total_fatigue;

output [
  "X=", show(X), " hours\n",
  "Y=", show(Y), " hours\n",
  "Z=", show(Z), " hours\n",
  "Minimum total fatigue (rounded) = ", show(total_fatigue), "\n"
];