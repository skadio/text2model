% Resource allocation for initiatives X, Y, Z with embedded data

int: BUDGET_MAX = 1000;

% Unit costs
int: cX = 2;
int: cY = 3;
int: cZ = 4;

% Bounds (not specified numerically in the description beyond nonnegativity,
% so we use operationally natural bounds consistent with the total budget)
int: X_min = 0; int: X_max = BUDGET_MAX;
int: Y_min = 0; int: Y_max = BUDGET_MAX;
int: Z_min = 0; int: Z_max = BUDGET_MAX;

var X_min..X_max: X;
var Y_min..Y_max: Y;
var Z_min..Z_max: Z;

constraint X + Y + Z <= BUDGET_MAX;

% X requires at least 100 more than twice Y
constraint X >= 2*Y + 100;

% |Y - Z| <= 50
constraint abs(Y - Z) <= 50;

% X + Z >= 300
constraint X + Z >= 300;

var int: total_cost = cX*X + cY*Y + cZ*Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];