% Parameters
int: cal_banana = 80;
int: k_banana   = 20;
int: s_banana   = 10;

int: cal_mango  = 100;
int: k_mango    = 15;
int: s_mango    = 8;

int: min_cal = 4000;
int: min_k   = 150;

% Variables
var 0..1000: bananas;
var 0..1000: mangoes;

% Constraints
constraint cal_banana * bananas + cal_mango * mangoes >= min_cal;
constraint k_banana   * bananas + k_mango   * mangoes >= min_k;

% At most 33% mangoes: mangoes <= 0.33 * (bananas + mangoes)
% Use integer-safe form: 100*mangoes <= 33*(bananas + mangoes)
constraint 100 * mangoes <= 33 * (bananas + mangoes);

% Objective
solve minimize s_banana * bananas + s_mango * mangoes;