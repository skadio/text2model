% Parameters
% Nutrient content per pack
int: antioxidants_blueberries  = 3;
int: minerals_blueberries      = 5;
int: antioxidants_strawberries = 1;
int: minerals_strawberries     = 7;

% Minimum required intake
int: min_antioxidants = 90;
int: min_minerals     = 100;

% Ratio requirement: strawberries >= ratio_sb * blueberries
int: ratio_sb = 3;

% Sugar per pack (objective coefficients)
int: sugar_blueberries  = 5;
int: sugar_strawberries = 7;

% Conservative upper bound to keep the model bounded
int: max_packs = 200;


% Variables
var 0..max_packs: packs_blueberries;    % number of blueberry packs
var 0..max_packs: packs_strawberries;   % number of strawberry packs

% Total sugar intake (bounded using max_packs)
var 0..(sugar_blueberries*max_packs + sugar_strawberries*max_packs): total_sugar;


% Constraints
% --- Nutrient requirements (minimum antioxidants and minerals) ---
constraint
  antioxidants_blueberries * packs_blueberries
+ antioxidants_strawberries * packs_strawberries
>= min_antioxidants;

constraint
  minerals_blueberries * packs_blueberries
+ minerals_strawberries * packs_strawberries
>= min_minerals;

% --- Seasonal/ratio requirement: strawberries at least 3x blueberries ---
constraint
  packs_strawberries >= ratio_sb * packs_blueberries;

% --- Define total sugar intake consistently with decision variables ---
constraint
  total_sugar
  = sugar_blueberries * packs_blueberries
  + sugar_strawberries * packs_strawberries;


% Objective
solve minimize total_sugar;