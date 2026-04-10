% Parameters (with values embedded)
int: minHoursX = 10;
int: minHoursY = 5;
int: maxTotalHours = 40;
int: costPerHourX = 50;
int: costPerHourY = 80;

% Variables
var minHoursX..maxTotalHours: hoursX;
var minHoursY..maxTotalHours: hoursY;
var 0..(costPerHourX*maxTotalHours + costPerHourY*maxTotalHours): totalCost;

% Constraints
constraint hoursX + hoursY <= maxTotalHours;
constraint totalCost = costPerHourX * hoursX + costPerHourY * hoursY;

% Objective
solve minimize totalCost;