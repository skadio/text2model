% Parameters
int: costSolar = 10;
int: costWind  = 15;
int: costNuc   = 20;

int: totalMin = 10000;
int: diffMax  = 5000;
int: nucMoreThanWind = 2000;

% Variables
var 0..totalMin: Solar;
var 0..totalMin: Wind;
var 0..totalMin: Nuclear;

var 0..(costSolar*totalMin + costWind*totalMin + costNuc*totalMin): TotalCost;

% Constraints
constraint Solar + Wind + Nuclear >= totalMin;

constraint abs(Solar - Wind) <= diffMax;

constraint Nuclear >= Wind + nucMoreThanWind;

constraint TotalCost = costSolar*Solar + costWind*Wind + costNuc*Nuclear;

% Objective
solve minimize TotalCost;