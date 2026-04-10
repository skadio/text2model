int: total_investment = 10000000;

int: min_X = 2000000;
int: max_Y = 5000000;
int: min_Z = 1500000;
int: max_W = 3000000;

int: rX = 5;
int: rY = 7;
int: rZ = 6;
int: rW = 8;

var 0..total_investment: X;
var 0..total_investment: Y;
var 0..total_investment: Z;
var 0..total_investment: W;

var 0..(total_investment * 100): total_return_cents;

constraint X + Y + Z + W = total_investment;

constraint X >= min_X;
constraint Y <= max_Y;
constraint Z >= min_Z;
constraint W <= max_W;

constraint total_return_cents = rX * X + rY * Y + rZ * Z + rW * W;

solve minimize total_return_cents;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "W=", show(W), "\n",
  "min_total_return_dollars=", show(total_return_cents div 100), "\n"
];