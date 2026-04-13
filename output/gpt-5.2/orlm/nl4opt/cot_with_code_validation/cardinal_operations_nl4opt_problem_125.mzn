% Parameters
int: cal_banana = 80;
int: pot_banana = 20;
int: sug_banana = 10;

int: cal_mango  = 100;
int: pot_mango  = 15;
int: sug_mango  = 8;

int: min_cal = 4000;
int: min_pot = 150;

% Variables
var 0..1000: bananas;
var 0..1000: mangoes;

% Constraints
constraint cal_banana * bananas + cal_mango * mangoes >= min_cal;
constraint pot_banana * bananas + pot_mango * mangoes >= min_pot;

% At most 33% mangoes: mangoes / (bananas + mangoes) <= 0.33
% Enforce as integer inequality: 100*mangoes <= 33*(bananas + mangoes)
constraint 100 * mangoes <= 33 * (bananas + mangoes);

% Objective
solve minimize sug_banana * bananas + sug_mango * mangoes;