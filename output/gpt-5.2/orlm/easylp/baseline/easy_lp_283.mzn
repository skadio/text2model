% Tourism agency budget allocation - minimize total cost
% All data embedded directly in the model.

var 10..50: X;   % campaign X allocation (units), minimum 10
var 15..50: Y;   % campaign Y allocation (units), minimum 15
var 5..50:  Z;   % campaign Z allocation (units), minimum 5

constraint X + Y + Z <= 50;

int: costX = 500;
int: costY = 400;
int: costZ = 300;

var int: total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "Minimum total investment cost (USD, nearest dollar) = ", show(total_cost), "\n"
];