% Parameters
int: calories_salmon = 300;        % calories per bowl of salmon
int: protein_salmon = 15;          % grams of protein per bowl of salmon
int: sodium_salmon  = 80;          % mg sodium per bowl of salmon

int: calories_eggs = 200;          % calories per bowl of eggs
int: protein_eggs  = 8;            % grams of protein per bowl of eggs
int: sodium_eggs   = 20;           % mg sodium per bowl of eggs

int: min_calories = 2000;          % minimum required calories
int: min_protein  = 90;            % minimum required protein (g)

int: egg_ratio_num = 40;           % at most 40% eggs (numerator)
int: egg_ratio_den = 100;          % at most 40% eggs (denominator)

% Safe upper bounds derived from meeting calorie requirement using only that meal
int: max_salmon = (min_calories + calories_salmon - 1) div calories_salmon;
int: max_eggs   = (min_calories + calories_eggs - 1) div calories_eggs;


% Variables
var 0..max_salmon: bowls_salmon;   % number of salmon bowls
var 0..max_eggs:   bowls_eggs;     % number of egg bowls


% Constraints

% Minimum calorie intake requirement
constraint
  calories_salmon * bowls_salmon + calories_eggs * bowls_eggs >= min_calories;

% Minimum protein intake requirement
constraint
  protein_salmon * bowls_salmon + protein_eggs * bowls_eggs >= min_protein;

% Egg-meal ratio limit: eggs are at most 40% of total meals
% bowls_eggs / (bowls_salmon + bowls_eggs) <= egg_ratio_num / egg_ratio_den
% Cross-multiplied to keep it linear and integer-safe:
constraint
  egg_ratio_den * bowls_eggs <= egg_ratio_num * (bowls_salmon + bowls_eggs);


% Objective
solve minimize sodium_salmon * bowls_salmon + sodium_eggs * bowls_eggs;