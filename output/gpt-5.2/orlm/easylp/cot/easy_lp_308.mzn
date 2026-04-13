% Parameters (with values embedded)
int: MAX_UNITS = 10000;
int: MIN_EFFECT = 20000;

int: effX = 5;
int: effY = 3;
int: effZ = 7;

int: costX = 500;
int: costY = 300;
int: costZ = 700;

% Variables
var 0..MAX_UNITS: X;
var 0..MAX_UNITS: Y;
var 0..MAX_UNITS: Z;
var 0..(MAX_UNITS * max([costX, costY, costZ])): total_cost;

% Constraints
constraint X + Y + Z <= MAX_UNITS;
constraint effX * X + effY * Y + effZ * Z >= MIN_EFFECT;

constraint X >= Y;
constraint Z <= Y;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];