% Parameters (with values embedded)
int: cal_banana = 80;
int: pot_banana = 20;
int: sug_banana = 10;

int: cal_mango  = 100;
int: pot_mango  = 15;
int: sug_mango  = 8;

int: min_calories  = 4000;
int: min_potassium = 150;

% Variables
var 0..1000: bananas;
var 0..1000: mangoes;

% Constraints
constraint cal_banana * bananas + cal_mango * mangoes >= min_calories;
constraint pot_banana * bananas + pot_mango * mangoes >= min_potassium;

% At most 33% of fruits can be mangoes: mangoes <= 0.33*(bananas+mangoes)
% Use integer-safe form: 3*mangoes <= bananas + mangoes  <=> 2*mangoes <= bananas
constraint 2 * mangoes <= bananas;

% Objective
solve minimize sug_banana * bananas + sug_mango * mangoes;