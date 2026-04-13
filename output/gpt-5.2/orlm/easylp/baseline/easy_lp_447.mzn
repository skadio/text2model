% Resource allocation optimization for projects X and Y (integer units)

int: costX = 4;
int: costY = 5;

int: maxWeightedTotal = 100; % X + 3Y <= 100
int: minObjectiveReq = 50;   % 2X + Y >= 50
int: maxDiff = 20;           % |X - Y| <= 20

int: maxX = 60;
int: maxY = 30;

var 0..maxX: X;
var 0..maxY: Y;

constraint X + 3*Y <= maxWeightedTotal;
constraint 2*X + Y >= minObjectiveReq;
constraint abs(X - Y) <= maxDiff;

var int: total_cost = costX*X + costY*Y;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_cost=", show(total_cost), "\n",
  "rounded_min_cost=", show(total_cost), "\n"
];