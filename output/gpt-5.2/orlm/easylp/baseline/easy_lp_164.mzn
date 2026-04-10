int: costX = 150000;
int: costY = 200000;

var 0..10: X; % commercial buildings
var 0..10: Y; % residential complexes

constraint X + Y <= 10;
constraint 2*X + Y >= 10; % X + 0.5*Y >= 5

var int: total_investment = costX * X + costY * Y;

solve minimize total_investment;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total investment = $", show(total_investment), "\n"
];