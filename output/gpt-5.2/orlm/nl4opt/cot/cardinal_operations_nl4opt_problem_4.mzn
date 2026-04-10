% Parameters (with values embedded)
int: min_protein = 30;
int: min_fat = 50;

int: costA = 100;
int: costB = 80;

int: proteinA = 10;
int: fatA = 8;

int: proteinB = 7;
int: fatB = 15;

% Variables
var 0.0..1000.0: xA; % kilograms of Feed A
var 0.0..1000.0: xB; % kilograms of Feed B
var 0.0..1000000.0: total_cost;

% Constraints
constraint proteinA * xA + proteinB * xB >= min_protein;
constraint fatA * xA + fatB * xB >= min_fat;

constraint total_cost = costA * xA + costB * xB;

% Objective
solve minimize total_cost;