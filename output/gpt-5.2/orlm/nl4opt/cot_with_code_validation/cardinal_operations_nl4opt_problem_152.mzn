% Parameters
int: vitA_req = 150;
int: vitD_req = 300;
int: vitE_max = 400;

int: A_vitA = 8;
int: A_vitD = 6;
int: A_vitE = 10;
int: A_vitK = 4;

int: B_vitA = 15;
int: B_vitD = 2;
int: B_vitE = 20;
int: B_vitK = 12;

% Variables
var 0..200: cupsA;
var 0..200: cupsB;

var 0..4000: totalVitK;

% Constraints
constraint A_vitA * cupsA + B_vitA * cupsB >= vitA_req;
constraint A_vitD * cupsA + B_vitD * cupsB >= vitD_req;
constraint A_vitE * cupsA + B_vitE * cupsB <= vitE_max;

constraint totalVitK = A_vitK * cupsA + B_vitK * cupsB;

% Objective
solve minimize totalVitK;