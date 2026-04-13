% Diet planning / minimum cost to meet nutrient requirements

int: nFoods = 5;
set of int: FOODS = 1..nFoods;
set of int: NUTRIENTS = 1..3;  % 1=protein, 2=carbs, 3=calories

array[FOODS] of int: cost = [9, 9, 2, 9, 5];

% nutrient[f,n] = contribution of food f to nutrient n
array[FOODS, NUTRIENTS] of int: nutrient =
  array2d(FOODS, NUTRIENTS,
    [
      3, 16,  96,   % Food 1
     17, 24, 182,   % Food 2
     16, 27, 114,   % Food 3
      8, 16, 208,   % Food 4
      6,  6, 236    % Food 5
    ]);

array[NUTRIENTS] of int: req = [100, 180, 1796];

% Safe finite upper bounds from calorie requirement
array[FOODS] of int: maxQty = [
  req[3] div nutrient[1,3] + 1,
  req[3] div nutrient[2,3] + 1,
  req[3] div nutrient[3,3] + 1,
  req[3] div nutrient[4,3] + 1,
  req[3] div nutrient[5,3] + 1
];

% Decision variables
array[FOODS] of var 0..maxQty[f] : qty;

var 0..sum(f in FOODS)(cost[f] * maxQty[f]) : totalCost;

% Total cost
constraint totalCost = sum(f in FOODS)(cost[f] * qty[f]);

% Nutrient requirements
constraint
  forall(n in NUTRIENTS) (
    sum(f in FOODS)(nutrient[f,n] * qty[f]) >= req[n]
  );

solve minimize totalCost;