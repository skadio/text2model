% Parameters
int: calories_ramen = 400;        % calories per pack of ramen
int: protein_ramen  = 20;         % grams of protein per pack of ramen
int: sodium_ramen   = 100;        % mg of sodium per pack of ramen

int: calories_fries = 300;        % calories per pack of fries
int: protein_fries  = 10;         % grams of protein per pack of fries
int: sodium_fries   = 75;         % mg of sodium per pack of fries

int: min_calories = 3000;         % minimum total calories required
int: min_protein  = 80;           % minimum total protein required (grams)

float: max_ramen_fraction = 0.30; % at most 30% of meals can be ramen (documentary; enforced via integer-safe constraint)

% Variables
var 0..1000: ramen_packs;         % number of ramen packs eaten
var 0..1000: fries_packs;         % number of fries packs eaten

var 0..10000000: total_sodium;    % total sodium intake (mg), objective-related

% Constraints

% --- Nutrition requirements ---
% Meet minimum total calories.
constraint
  calories_ramen * ramen_packs + calories_fries * fries_packs >= min_calories;

% Meet minimum total protein.
constraint
  protein_ramen * ramen_packs + protein_fries * fries_packs >= min_protein;

% --- Meal composition (ramen fraction) ---
% At most 30% of meals can be ramen:
% ramen_packs <= 0.30 * (ramen_packs + fries_packs)
% Use integer-safe form to avoid float/int coercion:
% 10*ramen <= 3*(ramen+fries) -> 7*ramen <= 3*fries
constraint
  7 * ramen_packs <= 3 * fries_packs;

% --- Total sodium accounting ---
% Define total sodium intake from chosen packs.
constraint
  total_sodium = sodium_ramen * ramen_packs + sodium_fries * fries_packs;

% Objective
solve minimize total_sodium;

output [
  "ramen_packs = ", show(ramen_packs), "\n",
  "fries_packs = ", show(fries_packs), "\n",
  "total_sodium = ", show(total_sodium), " mg\n"
];