% Parameters
int: metal_J = 5;
int: water_J = 8;
int: poll_J  = 3;

int: metal_P = 9;
int: water_P = 6;
int: poll_P  = 5;

int: water_max = 1500;
int: poll_max  = 1350;

% Variables
var 0..(water_max div min(water_J, water_P)): xJ;
var 0..(water_max div min(water_J, water_P)): xP;

% Constraints
constraint water_J * xJ + water_P * xP <= water_max;
constraint poll_J  * xJ + poll_P  * xP <= poll_max;

% Objective
solve maximize metal_J * xJ + metal_P * xP;