% Tour operator planning problem (all data embedded)

int: max_total_tourists = 50;

int: min_X = 10;
int: min_Y = 5;
int: min_Z = 8;

int: cost_X = 100;
int: cost_Y = 80;
int: cost_Z = 150;

var min_X..max_total_tourists: X;
var min_Y..max_total_tourists: Y;
var min_Z..max_total_tourists: Z;

constraint X + Y + Z <= max_total_tourists;

var int: total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "TotalCost=", show(total_cost), "\n"
];