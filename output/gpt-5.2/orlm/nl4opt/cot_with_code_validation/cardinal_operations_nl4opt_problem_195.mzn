% Parameters
int: ironA = 5;
int: calciumA = 10;
int: ironB = 4;
int: calciumB = 15;

int: minIron = 40;
int: minCalcium = 50;

int: costA = 2;
int: costB = 3;

% Variables
var 0..1000: xA; % pills of supplement A
var 0..1000: xB; % pills of supplement B
var 0..(costA*1000 + costB*1000): totalCost;

% Constraints
constraint ironA * xA + ironB * xB >= minIron;
constraint calciumA * xA + calciumB * xB >= minCalcium;

constraint totalCost = costA * xA + costB * xB;

% Objective
solve minimize totalCost;