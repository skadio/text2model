% Parameters (with values embedded)
int: budget = 500;

int: costX = 50;
int: costY = 30;
int: costZ = 80;

int: reqXY = 400;     % 2*X + 3*Y >= 400
int: diffYZ = 150;    % |Y - Z| <= 150
int: diffXZ = 100;    % X - Z >= 100

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;

var 0..(costX*budget + costY*budget + costZ*budget): total_cost;

% Constraints
constraint X + Y + Z <= budget;

constraint 2*X + 3*Y >= reqXY;

constraint abs(Y - Z) <= diffYZ;

constraint X - Z >= diffXZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];