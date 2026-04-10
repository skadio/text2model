% Parameters
int: gold_available = 500;
int: wires_available = 300;

int: gold_A = 3;
int: wires_A = 2;
int: coins_A = 5;

int: gold_B = 5;
int: wires_B = 3;
int: coins_B = 7;

% Variables
var 0..(gold_available div gold_A): xA;
var 0..(gold_available div gold_B): xB;

% Constraints
constraint gold_A * xA + gold_B * xB <= gold_available;
constraint wires_A * xA + wires_B * xB <= wires_available;

% Objective
solve maximize coins_A * xA + coins_B * xB;