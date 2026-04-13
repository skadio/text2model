% Supply chain resource allocation: minimize total cost

int: BUDGET = 1000;
int: DEMAND = 800;
int: DIFF_LIMIT = 300;

% Costs per unit
int: cX = 2;
int: cY = 3;
int: cZ = 1;

% Effectiveness coefficients
int: aX = 3;
int: aY = 2;
int: aZ = 1;

% Specific bounds (not provided explicitly, so use natural budget-based bounds)
int: X_LB = 0; int: X_UB = BUDGET;
int: Y_LB = 0; int: Y_UB = BUDGET;
int: Z_LB = 0; int: Z_UB = BUDGET;

var X_LB..X_UB: X;
var Y_LB..Y_UB: Y;
var Z_LB..Z_UB: Z;

% Constraints
constraint X + Y + Z <= BUDGET;
constraint aX*X + aY*Y + aZ*Z >= DEMAND;
constraint abs(X - Y) <= DIFF_LIMIT;

% Objective: minimize total cost
var int: total_cost = cX*X + cY*Y + cZ*Z;
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n"
];