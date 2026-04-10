% Parameters
% Nutritional content per pack
int: antioxidants_blueberries = 3;
int: minerals_blueberries     = 5;
int: sugar_blueberries        = 5;

int: antioxidants_strawberries = 1;
int: minerals_strawberries     = 7;
int: sugar_strawberries        = 7;

% Minimum required intake
int: min_antioxidants = 90;
int: min_minerals     = 100;

% Ratio requirement: strawberries >= ratio * blueberries
int: strawberry_to_blueberry_ratio = 3;


% Variables
% Number of packs to consume (non-negative integers)
var 0..1000: packs_blueberries;   % packs of blueberries
var 0..1000: packs_strawberries;  % packs of strawberries

% Total sugar intake (bounded for use in objective/linear expressions)
var 0..20000: total_sugar;        % grams of sugar consumed


% Constraints

% --- Nutrient minimum requirements ---
constraint
  antioxidants_blueberries * packs_blueberries
+ antioxidants_strawberries * packs_strawberries
>= min_antioxidants;

constraint
  minerals_blueberries * packs_blueberries
+ minerals_strawberries * packs_strawberries
>= min_minerals;

% --- Seasonal/ratio requirement: strawberries >= ratio * blueberries ---
constraint
  packs_strawberries >= strawberry_to_blueberry_ratio * packs_blueberries;

% --- Define total sugar intake from chosen packs ---
constraint
  total_sugar =
    sugar_blueberries * packs_blueberries
  + sugar_strawberries * packs_strawberries;


% Objective
solve minimize total_sugar;