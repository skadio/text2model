% Parameters
int: N = 5;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [14, 10, 4, 19, 10];
array[FOODS] of int: carbs   = [28, 27, 13, 5, 8];
array[FOODS] of int: cal     = [184, 298, 162, 81, 147];
array[FOODS] of int: cost    = [5, 1, 5, 9, 9];

int: min_protein = 97;
int: min_carbs   = 140;
int: min_cal     = 2304;

% Variables
int: max_units = max( max( (min_protein + min(protein) - 1) div min(protein),
                           (min_carbs   + min(carbs)   - 1) div min(carbs)),
                      (min_cal     + min(cal)     - 1) div min(cal) );

array[FOODS] of var 0..max_units: x;

var 0..(max_units * max(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= min_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= min_carbs;
constraint sum(i in FOODS)(cal[i]     * x[i]) >= min_cal;

% Objective
solve minimize total_cost;