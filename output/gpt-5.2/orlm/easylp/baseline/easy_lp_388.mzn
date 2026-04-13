% Tourism resource allocation - minimize total cost

int: c1 = 50;
int: c2 = 100;
int: c3 = 200;
int: c4 = 300;

var 0..500: x1;
var 0..400: x2;
var 0..600: x3;
var 0..700: x4;

% Constraints
constraint x1 + x2 <= 500;
constraint x2 + x3 >= 300;
constraint abs(x3 - x4) <= 100;
constraint abs(x4 - x1) >= 50;

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];