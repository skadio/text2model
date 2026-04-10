% Parameters
int: sleepA = 3;
int: antiA  = 5;
int: costA  = 4;

int: sleepB = 6;
int: antiB  = 1;
int: costB  = 5;

int: minSleep = 40;
int: minAnti  = 50;

% Variables
var 0..1000: xA;  % number of pill A
var 0..1000: xB;  % number of pill B

var 0..1000000: totalCost;

% Constraints
constraint sleepA * xA + sleepB * xB >= minSleep;
constraint antiA  * xA + antiB  * xB >= minAnti;

constraint totalCost = costA * xA + costB * xB;

% Objective
solve minimize totalCost;