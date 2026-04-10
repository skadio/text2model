% Parameters
int: VitA_min = 150;
int: VitD_min = 300;
int: VitE_max = 400;

int: A_VitA = 8;
int: A_VitD = 6;
int: A_VitE = 10;
int: A_VitK = 4;

int: B_VitA = 15;
int: B_VitD = 2;
int: B_VitE = 20;
int: B_VitK = 12;

% Variables
var 0..10000: cupsA;
var 0..10000: cupsB;
var 0..1000000: totalK;

% Constraints
constraint A_VitA * cupsA + B_VitA * cupsB >= VitA_min;
constraint A_VitD * cupsA + B_VitD * cupsB >= VitD_min;
constraint A_VitE * cupsA + B_VitE * cupsB <= VitE_max;

constraint totalK = A_VitK * cupsA + B_VitK * cupsB;

% Objective
solve minimize totalK;