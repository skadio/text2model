% Transportation resource allocation - embedded data

int: max_total = 2000;

int: costX = 3;
int: costY = 2;
int: costZ = 1;

int: diff_X_vs_2Y = 1000;  % |X - 2Y| >= 1000
int: diff_Z_vs_Y  = 500;   % |Z - Y|  >= 500

var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;

constraint X + Y + Z <= max_total;

constraint abs(X - 2*Y) >= diff_X_vs_2Y;
constraint abs(Z - Y) >= diff_Z_vs_Y;

var int: total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n"
];