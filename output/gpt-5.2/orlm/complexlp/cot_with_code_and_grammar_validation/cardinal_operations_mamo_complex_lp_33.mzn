% Parameters
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [12, 12, 19, 19, 4];
array[FOODS] of int: carbs   = [2, 24, 18, 7, 27];
array[FOODS] of int: cal     = [186, 250, 134, 84, 104];
array[FOODS] of int: cost    = [6, 6, 6, 7, 9];

int: minProtein = 97;
int: minCarbs   = 163;
int: minCal     = 2217;

% Variables
int: maxServings = max(
  max( (minProtein + min(protein) - 1) div min(protein),
       (minCarbs   + min(carbs)   - 1) div min(carbs)),
  (minCal     + min(cal)     - 1) div min(cal)
);

array[FOODS] of var 0..maxServings: x;

var 0..(maxServings * sum(cost)): totalCost =
  sum(i in FOODS)(cost[i] * x[i]);

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= minCarbs;
constraint sum(i in FOODS)(cal[i]     * x[i]) >= minCal;

% Objective
solve minimize totalCost;