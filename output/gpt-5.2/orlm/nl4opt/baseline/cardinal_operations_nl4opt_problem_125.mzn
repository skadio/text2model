% Gorilla diet optimization: minimize sugar intake
% Decision variables: number of bananas and mangoes (nonnegative integers)

int: cal_banana = 80;
int: pot_banana = 20;
int: sug_banana = 10;

int: cal_mango = 100;
int: pot_mango = 15;
int: sug_mango = 8;

int: min_calories = 4000;
int: min_potassium = 150;

% Upper bounds (safe, derived from requirements)
int: max_bananas = max(ceil(min_calories div cal_banana) + 100, ceil(min_potassium div pot_banana) + 100);
int: max_mangoes = max(ceil(min_calories div cal_mango) + 100, ceil(min_potassium div pot_mango) + 100);

var 0..max_bananas: bananas;
var 0..max_mangoes: mangoes;

% Nutrition constraints
constraint cal_banana * bananas + cal_mango * mangoes >= min_calories;
constraint pot_banana * bananas + pot_mango * mangoes >= min_potassium;

% Preference constraint: at most 33% of fruits are mangoes
% mangoes / (bananas + mangoes) <= 1/3  <=>  3*mangoes <= bananas + mangoes  <=>  2*mangoes <= bananas
constraint 2 * mangoes <= bananas;

% Objective: minimize sugar intake
var int: total_sugar = sug_banana * bananas + sug_mango * mangoes;

solve minimize total_sugar;

output [
  "bananas=", show(bananas), "\n",
  "mangoes=", show(mangoes), "\n",
  "total_calories=", show(cal_banana*bananas + cal_mango*mangoes), "\n",
  "total_potassium=", show(pot_banana*bananas + pot_mango*mangoes), "\n",
  "total_sugar=", show(total_sugar), "\n"
];