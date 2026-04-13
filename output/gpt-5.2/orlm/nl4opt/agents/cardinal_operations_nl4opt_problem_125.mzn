% Parameters
% Nutritional content per fruit
int: cal_banana = 80;      % calories per banana
int: pot_banana = 20;      % grams of potassium per banana
int: sug_banana = 10;      % grams of sugar per banana

int: cal_mango  = 100;     % calories per mango
int: pot_mango  = 15;      % grams of potassium per mango
int: sug_mango  = 8;       % grams of sugar per mango

% Minimum required intake
int: min_calories  = 4000; % minimum calories required
int: min_potassium = 150;  % minimum grams of potassium required

% Preference constraint: at most 33% of fruits are mangoes
% mangoes / (bananas + mangoes) <= 1/3  <=>  2*mangoes <= bananas
int: mango_ratio_num = 1;
int: mango_ratio_den = 3;

% Variables
var 0..1000: bananas;      % number of bananas (nonnegative integer)
var 0..1000: mangoes;      % number of mangoes (nonnegative integer)

% Objective variable for clarity
var 0..20000: total_sugar; % total grams of sugar to minimize

% Constraints

% --- Nutritional minimums ---
constraint
  cal_banana * bananas + cal_mango * mangoes >= min_calories;

constraint
  pot_banana * bananas + pot_mango * mangoes >= min_potassium;

% --- Preference / composition constraint (at most 33% mangoes) ---
% (den-num)*mangoes <= num*bananas  -> (3-1)*mangoes <= 1*bananas -> 2*mangoes <= bananas
constraint
  (mango_ratio_den - mango_ratio_num) * mangoes <= mango_ratio_num * bananas;

% --- Total sugar accounting ---
constraint
  total_sugar = sug_banana * bananas + sug_mango * mangoes;

% Objective
solve minimize total_sugar;