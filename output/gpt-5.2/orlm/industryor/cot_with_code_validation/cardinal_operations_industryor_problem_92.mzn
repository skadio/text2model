% Parameters
int: milk_barrels = 50;
int: labor_hours = 480;

int: a1_kg_per_barrel = 3;
int: a2_kg_per_barrel = 4;

int: a_time_per_barrel = 12; % hours for Type A to process 1 barrel into A1
int: b_time_per_barrel = 8;  % hours for Type B to process 1 barrel into A2

int: profit_a1_per_kg = 24;
int: profit_a2_per_kg = 16;

int: a1_capacity_kg = 100;

% Variables
var 0..milk_barrels: xA; % barrels processed on Type A (into A1)
var 0..milk_barrels: xB; % barrels processed on Type B (into A2)

var 0..(milk_barrels * a1_kg_per_barrel): kgA1;
var 0..(milk_barrels * a2_kg_per_barrel): kgA2;

var 0..(profit_a1_per_kg * milk_barrels * a1_kg_per_barrel
      + profit_a2_per_kg * milk_barrels * a2_kg_per_barrel): total_profit;

% Constraints
constraint xA + xB <= milk_barrels;

constraint a_time_per_barrel * xA + b_time_per_barrel * xB <= labor_hours;

constraint kgA1 = a1_kg_per_barrel * xA;
constraint kgA2 = a2_kg_per_barrel * xB;

constraint kgA1 <= a1_capacity_kg;

constraint total_profit = profit_a1_per_kg * kgA1 + profit_a2_per_kg * kgA2;

% Objective
solve maximize total_profit;