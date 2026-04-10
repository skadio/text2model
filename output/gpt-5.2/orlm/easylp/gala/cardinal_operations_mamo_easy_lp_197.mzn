% Budget allocation across portfolios X, Y, Z (whole dollars), minimize total cost.

% Data (embedded as requested)
int: BUDGET = 50000;
int: minDiffXY = 10000;  % X >= Y + 10000
int: minDiffYZ = 5000;   % Y >= Z + 5000

int: costX = 1000;       % cost per $1 invested in X
int: costY = 800;        % cost per $1 invested in Y
int: costZ = 600;        % cost per $1 invested in Z

% Decision variables (whole dollars)
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

% Constraints
constraint X + Y + Z <= BUDGET;
constraint X >= Y + minDiffXY;
constraint Y >= Z + minDiffYZ;

% Objective: minimize total cost
var 0..(costX*BUDGET + costY*BUDGET + costZ*BUDGET): totalCost;
constraint totalCost = costX*X + costY*Y + costZ*Z;

solve minimize totalCost;

output [
  "X = $", show(X), "\n",
  "Y = $", show(Y), "\n",
  "Z = $", show(Z), "\n",
  "Total cost (nearest dollar) = $", show(totalCost), "\n"
];