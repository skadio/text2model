% Energy investment allocation optimization (all data embedded)

int: BUDGET = 1000;

int: costX = 20;
int: costY = 30;
int: costZ = 40;

var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

% Budget constraint
constraint X + Y + Z <= BUDGET;

% 2X - (Y + Z) >= 300
constraint 2*X - Y - Z >= 300;

% X - 3Y - Z = 200  (interpreting "negative times the allocation of Z" as -Z)
constraint X - 3*Y - Z = 200;

var int: total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n",
  "rounded_total_cost=", show(total_cost), "\n"
];