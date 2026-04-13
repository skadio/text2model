% Energy investment optimization (all data embedded)

int: BUDGET = 1000;

% Decision variables: whole-number investments
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

% Constraints
constraint X + Y + Z <= BUDGET;
constraint 5 * X - 2 * Y >= 200;
constraint Z - Y <= 300;
constraint X >= Z + 50;

% Costs per unit
int: cX = 2;
int: cY = 3;
int: cZ = 4;

var 0..(cX*BUDGET + cY*BUDGET + cZ*BUDGET): total_cost;
constraint total_cost = cX * X + cY * Y + cZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];