% Parameters
int: gas_available = 1000;
int: water_available = 800;

int: gas_A = 5;
int: water_A = 6;
int: yield_A = 10;

int: gas_B = 7;
int: water_B = 3;
int: yield_B = 8;

% Variables
var 0..(gas_available div gas_A): xA; % number of reaction A runs
var 0..(gas_available div gas_B): xB; % number of reaction B runs

% Constraints
constraint gas_A * xA + gas_B * xB <= gas_available;
constraint water_A * xA + water_B * xB <= water_available;

% Objective
solve maximize yield_A * xA + yield_B * xB;