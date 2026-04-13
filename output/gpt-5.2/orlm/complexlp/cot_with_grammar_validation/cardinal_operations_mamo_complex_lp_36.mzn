% Parameters
int: N = 4;
set of int: FOODS = 1..N;
set of int: NUTS = 1..3; % 1=protein, 2=carbs, 3=calories

array[FOODS] of int: cost = [4, 1, 9, 4];

array[FOODS, NUTS] of int: nutr = 
  [| 20,  2,  68   % Steak
   |  7,  3,  143  % Eggs
   |  1, 26,  52   % Pasta
   | 10,  1,  69   % Chicken
  |];

array[NUTS] of int: req = [71, 141, 1839];

% Variables
array[FOODS] of var 0..3000: x; % number of units of each food
var 0..100000: total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint forall(n in NUTS)(
  sum(i in FOODS)(nutr[i,n] * x[i]) >= req[n]
);

% Objective
solve minimize total_cost;