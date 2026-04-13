% Parameters
int: matA = 30;
int: mrnaA = 50;
int: matB = 40;
int: mrnaB = 30;

int: matAvail = 300;
int: mrnaAvail = 400;

int: maxA = 5;

int: treatA = 12;
int: treatB = 8;

% Variables
var 0..maxA: xA;
var 0..10: xB; % safe upper bound from material: 40*xB <= 300 => xB <= 7; plus xA>=0

var 0..(treatA*maxA + treatB*10): totalTreated;

% Constraints
constraint matA * xA + matB * xB <= matAvail;
constraint mrnaA * xA + mrnaB * xB <= mrnaAvail;

constraint xB > xA;

constraint totalTreated = treatA * xA + treatB * xB;

% Objective
solve maximize totalTreated;