% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [19, 4, 3, 8];
array[FOODS] of int: carbs   = [9, 16, 11, 7];
array[FOODS] of int: cal     = [83, 166, 71, 56];
array[FOODS] of int: cost    = [7, 7, 10, 2];

int: reqProtein = 84;
int: reqCarbs   = 132;
int: reqCal     = 1990;

% Variables
% Upper bounds derived from meeting calories using the smallest calorie item (Food 4: 56 cal)
int: UB = (reqCal div 56) + 1;  % safe integer upper bound
array[FOODS] of var 0..UB: x;

var 0..(UB * max(cost)): totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(cal[i]     * x[i]) >= reqCal;

% Objective
solve minimize totalCost;