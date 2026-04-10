% Parameters
% Resource availability
int: flour_available = 150;
int: liquid_available = 100;
int: waste_max = 30;

% Beaker 1 coefficients
int: flour_per_beaker1 = 4;
int: liquid_per_beaker1 = 6;
int: slime_per_beaker1 = 5;
int: waste_per_beaker1 = 4;

% Beaker 2 coefficients
int: flour_per_beaker2 = 6;
int: liquid_per_beaker2 = 3;
int: slime_per_beaker2 = 3;
int: waste_per_beaker2 = 2;


% Variables
% Number of times each beaker is used (non-negative integers), bounded by individual resource limits
var 0..min(flour_available div flour_per_beaker1, liquid_available div liquid_per_beaker1): beaker1_uses;
var 0..min(flour_available div flour_per_beaker2, liquid_available div liquid_per_beaker2): beaker2_uses;

% Total slime produced (bounded for safe linear modeling)
var 0..(slime_per_beaker1 * (flour_available div flour_per_beaker1) +
        slime_per_beaker2 * (flour_available div flour_per_beaker2)): total_slime;


% Constraints
% Link total slime to the number of uses of each beaker
constraint
  total_slime =
    slime_per_beaker1 * beaker1_uses +
    slime_per_beaker2 * beaker2_uses;

% Flour availability constraint
constraint
  flour_per_beaker1 * beaker1_uses +
  flour_per_beaker2 * beaker2_uses
  <= flour_available;

% Special liquid availability constraint
constraint
  liquid_per_beaker1 * beaker1_uses +
  liquid_per_beaker2 * beaker2_uses
  <= liquid_available;

% Waste production constraint
constraint
  waste_per_beaker1 * beaker1_uses +
  waste_per_beaker2 * beaker2_uses
  <= waste_max;


% Objective
solve maximize total_slime;