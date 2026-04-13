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
var 0..(matAvail div matB): xB;

var 0..(treatA * maxA + treatB * (matAvail div matB)): totalTreated;

% Constraints
constraint matA * xA + matB * xB <= matAvail;
constraint mrnaA * xA + mrnaB * xB <= mrnaAvail;

constraint xB > xA;

constraint totalTreated = treatA * xA + treatB * xB;

% Objective
solve maximize totalTreated;