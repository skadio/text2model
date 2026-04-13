% Resource allocation for crops X, Y, Z (all integers), minimize total cost.

var 0..1000: X;
var 0..1000: Y;
var 0..800:  Z;

constraint X + Y <= 1000;      % land constraint
constraint Y + Z <= 800;       % water constraint
constraint X + Z >= 500;       % diversity constraint
constraint abs(X - Y) <= 200;  % nutrient balance

var int: total_cost = 20*X + 30*Y + 10*Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];