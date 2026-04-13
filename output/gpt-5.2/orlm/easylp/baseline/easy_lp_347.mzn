% Investment allocation problem (all data embedded)

int: TotalInvestment = 10_000_000;

int: minX = 2_000_000;
int: maxY = 5_000_000;
int: minZ = 1_500_000;
int: maxW = 3_000_000;

% Returns per dollar invested
float: rX = 0.05;
float: rY = 0.07;
float: rZ = 0.06;
float: rW = 0.08;

% Decision variables (whole dollars)
var 0..TotalInvestment: X;
var 0..TotalInvestment: Y;
var 0..TotalInvestment: Z;
var 0..TotalInvestment: W;

constraint X + Y + Z + W = TotalInvestment;

constraint X >= minX;
constraint Y <= maxY;
constraint Z >= minZ;
constraint W <= maxW;

% Objective: minimize total return (in dollars)
var float: total_return = rX*X + rY*Y + rZ*Z + rW*W;

solve minimize total_return;

output [
  "X = $", show(X), "\n",
  "Y = $", show(Y), "\n",
  "Z = $", show(Z), "\n",
  "W = $", show(W), "\n",
  "Minimum total return (rounded to nearest dollar) = $", show(round(total_return)), "\n"
];