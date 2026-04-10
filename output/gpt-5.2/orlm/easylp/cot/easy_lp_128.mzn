% Parameters (with values embedded)
int: costX = 20;
int: costY = 30;

int: effX = 3;
int: effY = 1;
int: minEffectiveness = 10;

int: maxManpowerX = 1;
int: maxManpowerY = 5;
int: maxManpower = 50;

% Variables
var 0..maxManpower: x; % units of Project X (trees)
var 0..(maxManpower div maxManpowerY): y; % units of Project Y (rivers)

var 0..(costX*maxManpower + costY*(maxManpower div maxManpowerY)): totalCost;

% Constraints
constraint totalCost = costX * x + costY * y;

constraint effX * x + effY * y >= minEffectiveness;

constraint maxManpowerX * x + maxManpowerY * y <= maxManpower;

% Objective
solve minimize totalCost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=$", show(totalCost), "\n"
];