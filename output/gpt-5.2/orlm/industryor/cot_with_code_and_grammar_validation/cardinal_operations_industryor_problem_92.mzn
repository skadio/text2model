% Parameters
int: milk_barrels = 50;
int: labor_hours = 480;

int: kgA1_per_barrel = 3;
int: kgA2_per_barrel = 4;

int: hoursA_per_barrel = 12;
int: hoursB_per_barrel = 8;

int: profitA1_per_kg = 24;
int: profitA2_per_kg = 16;

int: capA1_kg = 100;

% Variables
var 0..milk_barrels: bA;                % barrels allocated to produce A1
var 0..milk_barrels: bB;                % barrels allocated to produce A2
var 0..(milk_barrels * kgA1_per_barrel): xA1;   % kg of A1 produced
var 0..(milk_barrels * kgA2_per_barrel): xA2;   % kg of A2 produced
var int: profit;

% Constraints
constraint bA + bB <= milk_barrels;

constraint hoursA_per_barrel * bA + hoursB_per_barrel * bB <= labor_hours;

constraint xA1 = kgA1_per_barrel * bA;
constraint xA2 = kgA2_per_barrel * bB;

constraint xA1 <= capA1_kg;

% Objective
constraint profit = profitA1_per_kg * xA1 + profitA2_per_kg * xA2;
solve maximize profit;