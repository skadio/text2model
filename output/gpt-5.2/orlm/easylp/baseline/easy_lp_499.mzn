int: costX = 5000;
int: costY = 3000;

var int: X; % residential properties
var int: Y; % commercial properties

constraint X >= 20;
constraint Y >= 10;

constraint X + Y >= 50;
constraint 2*X + Y <= 120;
constraint X - 3*Y >= 10;

solve minimize costX*X + costY*Y;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = $", show(costX*X + costY*Y), "\n"
];