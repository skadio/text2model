% Parameters
int: water_limit = 1500;
int: pollution_limit = 1350;

int: metal_J = 5;
int: water_J = 8;
int: pollution_J = 3;

int: metal_P = 9;
int: water_P = 6;
int: pollution_P = 5;

% Variables
var 0..(water_limit div water_J): xJ;
var 0..(water_limit div water_P): xP;

% Constraints
constraint water_J * xJ + water_P * xP <= water_limit;
constraint pollution_J * xJ + pollution_P * xP <= pollution_limit;

% Objective
solve maximize metal_J * xJ + metal_P * xP;