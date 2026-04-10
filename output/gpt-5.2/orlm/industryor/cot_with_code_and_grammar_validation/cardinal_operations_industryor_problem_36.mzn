% Parameters
int: procI_A = 4;
int: procI_B = 6;
int: capI = 150;

int: procII_A = 3;
int: procII_B = 2;
int: capII = 70;

int: profitA = 300;
int: profitB = 450;

int: minProfit = 10000;
int: minA = 10;
int: minB = 15;

% Variables
var 0..1000: xA;
var 0..1000: xB;

var int: totalProfit;
var int: timeI;
var int: timeII;

% Constraints
constraint xA >= minA;
constraint xB >= minB;

constraint timeI = procI_A * xA + procI_B * xB;
constraint timeII = procII_A * xA + procII_B * xB;

constraint timeI <= capI;
constraint timeII <= capII;

constraint totalProfit = profitA * xA + profitB * xB;
constraint totalProfit >= minProfit;

% Objective
solve maximize totalProfit;