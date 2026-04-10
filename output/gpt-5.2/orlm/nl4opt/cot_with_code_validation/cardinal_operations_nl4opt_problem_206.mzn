% Parameters
int: calA = 30;
int: magA = 50;
int: costA = 14;

int: calB = 60;
int: magB = 10;
int: costB = 25;

int: reqCal = 400;
int: reqMag = 50;

% Variables
var 0..1000: xA; % servings of supplement A
var 0..1000: xB; % servings of supplement B

var 0..1000000: totalCost;

% Constraints
constraint calA * xA + calB * xB >= reqCal;
constraint magA * xA + magB * xB >= reqMag;

constraint totalCost = costA * xA + costB * xB;

% Objective
solve minimize totalCost;