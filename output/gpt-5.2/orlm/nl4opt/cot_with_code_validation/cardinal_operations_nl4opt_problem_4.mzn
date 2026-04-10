% Parameters
int: costA = 100;
int: costB = 80;

int: proteinA = 10;
int: fatA = 8;

int: proteinB = 7;
int: fatB = 15;

int: minProtein = 30;
int: minFat = 50;

int: ubA = max(minProtein div proteinA + 10, minFat div fatA + 10);
int: ubB = max(minProtein div proteinB + 10, minFat div fatB + 10);

% Variables
var 0..ubA: xA; % kilograms of Feed A
var 0..ubB: xB; % kilograms of Feed B
var 0..(costA * ubA + costB * ubB): totalCost;

% Constraints
constraint proteinA * xA + proteinB * xB >= minProtein;
constraint fatA * xA + fatB * xB >= minFat;

constraint totalCost = costA * xA + costB * xB;

% Objective
solve minimize totalCost;