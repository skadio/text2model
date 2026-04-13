% Crop planning: minimize total planting cost with embedded data

int: costX = 100;
int: costY = 50;

int: fertX = 3;
int: fertY = 2;
int: fertMax = 1000;

int: minTotalAcres = 200;
int: diffMax = 300;

int: maxX = 500;
int: maxY = 400;

var 0..maxX: x; % acres of crop X (integer)
var 0..maxY: y; % acres of crop Y (integer)

constraint fertX * x + fertY * y <= fertMax;
constraint x + y >= minTotalAcres;
constraint abs(x - y) <= diffMax;

var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x_acres = ", show(x), "\n",
  "y_acres = ", show(y), "\n",
  "total_cost = $", show(totalCost), "\n"
];