% Parameters
int: ironA = 5;
int: calA  = 10;
int: ironB = 4;
int: calB  = 15;

int: minIron = 40;
int: minCal  = 50;

int: costA = 2;
int: costB = 3;

% Variables
var 0..100: xA; % pills of supplement A
var 0..100: xB; % pills of supplement B

% Constraints
constraint ironA * xA + ironB * xB >= minIron;
constraint calA  * xA + calB  * xB >= minCal;

% Objective
solve minimize costA * xA + costB * xB;