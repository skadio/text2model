% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;
set of int: NUTRIENTS = 1..3; % 1=protein, 2=carbs, 3=calories

array[FOODS] of int: cost = [7, 10, 9, 2];

array[FOODS, NUTRIENTS] of int: nut = 
[| 17,  6,  94   % Chicken
 | 20, 13,  74   % Rice
 |  3, 25,  73   % Broccoli
 | 18, 20, 119   % Eggs
 |];

array[NUTRIENTS] of int: req = [84, 117, 1554];

% Variables
array[FOODS] of var 0..1000: x; % quantity of each food item

var 0..1000000: total_cost;

% Constraints
constraint total_cost = sum(f in FOODS)(cost[f] * x[f]);

constraint forall(n in NUTRIENTS)(
  sum(f in FOODS)(nut[f,n] * x[f]) >= req[n]
);

% Objective
solve minimize total_cost;