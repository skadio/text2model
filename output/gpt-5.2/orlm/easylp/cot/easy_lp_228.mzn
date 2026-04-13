% Parameters (with values embedded)
int: costX = 5;
int: costY = 4;
int: costZ = 6;

int: min_c1 = 10;  % 2X + 3Y + Z >= 10
int: max_c2 = 8;   % X - Y + Z <= 8
int: min_c3 = 3;   % Y - Z >= 3

% Variable bounds (derived to keep the model finite while preserving feasibility/optimality)
% From Y - Z >= 3 and nonnegativity => Y >= 3
int: X_ub = 8;   % from X - Y + Z <= 8 and (Z - Y) <= -3 => X <= 5; using safe upper bound 8
int: Y_ub = 10;  % safe bound
int: Z_ub = 7;   % safe bound

% Variables
var 0..X_ub: X;
var 0..Y_ub: Y;
var 0..Z_ub: Z;

% Constraints
constraint 2*X + 3*Y + Z >= min_c1;
constraint X - Y + Z <= max_c2;
constraint Y - Z >= min_c3;

% Objective
var int: total_cost = costX*X + costY*Y + costZ*Z;
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];