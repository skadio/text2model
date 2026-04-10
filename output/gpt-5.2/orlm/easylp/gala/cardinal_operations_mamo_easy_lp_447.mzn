% Resource allocation optimization for projects X and Y
% All data embedded as required.

int: costX = 4;
int: costY = 5;

int: maxWeightedTotal = 100;   % x + 3y <= 100
int: minStrategic = 50;        % 2x + y >= 50
int: maxDiff = 20;             % |x - y| <= 20

int: maxX = 60;
int: maxY = 30;

var 0..maxX: x;  % allocation to Project X (integer units)
var 0..maxY: y;  % allocation to Project Y (integer units)

constraint x + 3 * y <= maxWeightedTotal;
constraint 2 * x + y >= minStrategic;
constraint abs(x - y) <= maxDiff;

var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_total_cost = ", show(totalCost), "\n"
];