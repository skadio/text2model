% Embedded data (no .dzn needed)
int: BUDGET = 5000;
int: cX = 20;
int: cY = 15;
int: cZ = 30;

% Bounded decision variables to avoid unbounded/infinite search
% (Costs are positive and X+Y+Z<=BUDGET, so restricting to 0..BUDGET is safe.)
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

var 0..(cX*BUDGET + cY*BUDGET + cZ*BUDGET): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET;
constraint X >= 2000 - 3 * Y;
constraint Z >= Y + 1000;

constraint total_cost = cX * X + cY * Y + cZ * Z;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n"
];