% Tourism agency resource allocation - embedded data

var 0..200: X;  % units allocated to strategy X
var 0..200: Y;  % units allocated to strategy Y

constraint X + Y <= 200;
constraint 2*X + Y >= 150;
constraint abs(X - Y) <= 50;

var int: total_cost = 50*X + 80*Y;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Minimum total cost ($)=", show(total_cost), "\n"
];