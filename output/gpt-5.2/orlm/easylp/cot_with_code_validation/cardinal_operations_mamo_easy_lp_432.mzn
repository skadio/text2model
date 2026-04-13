% Parameters
int: costX = 7;
int: costY = 9;

int: riskCoefX = 4;
int: riskCoefY = 5;
int: riskMax = 1000;

int: balanceCoefX = 3;
int: balanceCoefY = 2;
int: balanceMin = 200;

int: investMax = 300;

% Variables
var 0..investMax: x;
var 0..investMax: y;

% Constraints
constraint riskCoefX * x + riskCoefY * y <= riskMax;

constraint balanceCoefX * x - balanceCoefY * y >= balanceMin;

constraint x + y <= investMax;

% Objective
solve minimize costX * x + costY * y;