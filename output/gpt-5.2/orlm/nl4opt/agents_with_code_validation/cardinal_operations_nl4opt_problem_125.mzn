% Parameters
% Nutritional content per fruit
int: calories_banana   = 80;
int: potassium_banana  = 20;
int: sugar_banana      = 10;

int: calories_mango    = 100;
int: potassium_mango   = 15;
int: sugar_mango       = 8;

% Minimum required intake
int: min_calories      = 4000;
int: min_potassium     = 150;

% Mango proportion limit (at most 33% mangoes)
int: max_mango_percent = 33;

% Safe upper bounds (derived from calorie requirement; ensures bounded variables)
int: max_bananas = min_calories div calories_banana + 100; % 4000/80=50 -> give slack
int: max_mangoes = min_calories div calories_mango + 100;  % 4000/100=40 -> give slack

% Variables
var 0..max_bananas: bananas; % number of bananas to feed
var 0..max_mangoes: mangoes; % number of mangoes to feed

var 0..(sugar_banana*max_bananas + sugar_mango*max_mangoes): total_sugar; % total sugar intake

% Constraints
% --- Total sugar definition ---
constraint
  total_sugar = sugar_banana * bananas + sugar_mango * mangoes;

% --- Minimum nutrition requirements ---
constraint
  calories_banana * bananas + calories_mango * mangoes >= min_calories;

constraint
  potassium_banana * bananas + potassium_mango * mangoes >= min_potassium;

% --- Mango proportion limit: mangoes <= 33% of total fruits ---
% Avoid division by cross-multiplying: 100*mangoes <= max_mango_percent*(bananas + mangoes)
constraint
  100 * mangoes <= max_mango_percent * (bananas + mangoes);

% Objective
solve minimize total_sugar;