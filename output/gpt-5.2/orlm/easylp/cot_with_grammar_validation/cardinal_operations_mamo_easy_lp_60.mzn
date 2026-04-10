% Parameters
int: costX = 2000;
int: costY = 3000;

int: perfX = 5;
int: perfY = 10;
int: minPerf = 50;

int: usageX = 3;
int: usageY = 4;
int: maxUsage = 40;

% Variables
var 0..ceil(int2float(maxUsage) / int2float(usageX)): X;
var 0..ceil(int2float(maxUsage) / int2float(usageY)): Y;

var int: totalCost = costX * X + costY * Y;

% Constraints
constraint perfX * X + perfY * Y >= minPerf;
constraint usageX * X + usageY * Y <= maxUsage;

% Objective
solve minimize totalCost;