% Parameters (with values embedded)
int: costX = 2000;
int: costY = 3000;

int: perfCoeffX = 5;
int: perfCoeffY = 10;
int: minPerformance = 50;

int: usageCoeffX = 3;
int: usageCoeffY = 4;
int: maxUsage = 40;

% Variables
var 0..40: X; % resources allocated to project X (integer, nonnegative)
var 0..40: Y; % resources allocated to project Y (integer, nonnegative)

var 0..200000: totalCost; % upper bound safe given variable bounds

% Constraints
constraint perfCoeffX * X + perfCoeffY * Y >= minPerformance;
constraint usageCoeffX * X + usageCoeffY * Y <= maxUsage;

constraint totalCost = costX * X + costY * Y;

% Objective
solve minimize totalCost;