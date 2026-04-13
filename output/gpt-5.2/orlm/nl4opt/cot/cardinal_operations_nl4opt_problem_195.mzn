% Parameters (with values embedded)
int: ironA = 5;
int: calciumA = 10;
int: ironB = 4;
int: calciumB = 15;

int: minIron = 40;
int: minCalcium = 50;

int: costA = 2;
int: costB = 3;

% Variables
var 0..20: xA;   % number of pills of supplement A
var 0..20: xB;   % number of pills of supplement B

% Constraints
constraint ironA * xA + ironB * xB >= minIron;
constraint calciumA * xA + calciumB * xB >= minCalcium;

% Objective
var int: totalCost = costA * xA + costB * xB;
solve minimize totalCost;