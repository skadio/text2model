% Parameters
int: calories_ramen = 400;          % calories per pack of ramen
int: protein_ramen  = 20;           % grams of protein per pack of ramen
int: sodium_ramen   = 100;          % mg of sodium per pack of ramen

int: calories_fries = 300;          % calories per pack of fries
int: protein_fries  = 10;           % grams of protein per pack of fries
int: sodium_fries   = 75;           % mg of sodium per pack of fries

int: min_calories = 3000;           % minimum required calories
int: min_protein  = 80;             % minimum required protein (g)

float: max_ramen_fraction = 0.30;   % at most 30% of meals can be ramen (embedded for completeness)

% Variables
var 0..1000: ramen_packs;           % number of ramen packs eaten
var 0..1000: fries_packs;           % number of fries packs eaten

% Constraints
% --- Nutritional minimum requirements ---
constraint
  calories_ramen * ramen_packs + calories_fries * fries_packs >= min_calories;

constraint
  protein_ramen * ramen_packs + protein_fries * fries_packs >= min_protein;

% --- Ramen fraction limit (at most 30% of total meals) ---
% ramen_packs <= 0.30 * (ramen_packs + fries_packs)
% Avoid float/int coercion by multiplying through with integers: 10*ramen <= 3*(ramen+fries)
constraint
  10 * ramen_packs <= 3 * (ramen_packs + fries_packs);

% Objective
solve minimize sodium_ramen * ramen_packs + sodium_fries * fries_packs;