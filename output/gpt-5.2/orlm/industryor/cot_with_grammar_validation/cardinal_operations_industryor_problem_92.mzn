% Parameters
int: milk_barrels = 50;
int: labor_hours = 480;

int: kgA1_per_barrel = 3;
int: hoursA_per_barrel = 12;
int: profitA1_per_kg = 24;
int: capA1_kg = 100;

int: kgA2_per_barrel = 4;
int: hoursB_per_barrel = 8;
int: profitA2_per_kg = 16;

% Variables
var 0..milk_barrels: xA; % barrels of milk processed into A1
var 0..milk_barrels: xB; % barrels of milk processed into A2

var 0..(milk_barrels * kgA1_per_barrel): kgA1;
var 0..(milk_barrels * kgA2_per_barrel): kgA2;

var 0..(profitA1_per_kg * milk_barrels * kgA1_per_barrel
      + profitA2_per_kg * milk_barrels * kgA2_per_barrel): profit;

% Constraints
constraint xA + xB <= milk_barrels;

constraint hoursA_per_barrel * xA + hoursB_per_barrel * xB <= labor_hours;

constraint kgA1 = kgA1_per_barrel * xA;
constraint kgA2 = kgA2_per_barrel * xB;

constraint kgA1 <= capA1_kg;

constraint profit = profitA1_per_kg * kgA1 + profitA2_per_kg * kgA2;

% Objective
solve maximize profit;