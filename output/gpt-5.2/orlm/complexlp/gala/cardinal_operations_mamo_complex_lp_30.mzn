% Diet / meal planning: minimize cost while meeting minimum nutrition requirements

include "globals.mzn";

int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [8, 10, 3, 16, 4];    % Chicken, Pasta, Apples, Tuna, Rice
array[FOODS] of int: carbs   = [8, 30, 10, 29, 24];
array[FOODS] of int: cal     = [118, 131, 151, 235, 101];
array[FOODS] of int: cost    = [6, 10, 1, 9, 4];

int: minProtein = 93;
int: minCarbs   = 181;
int: minCal     = 1620;

% Upper bound: enough to meet calories using the smallest calorie item (101) => at most ceil(1620/101)=17
% Use a safe bound.
int: maxQty = 100;

array[FOODS] of var 0..maxQty: qty;

constraint sum(i in FOODS)(protein[i] * qty[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * qty[i]) >= minCarbs;
constraint sum(i in FOODS)(cal[i]     * qty[i]) >= minCal;

var int: totalCost = sum(i in FOODS)(cost[i] * qty[i]);

solve minimize totalCost;

output [ show(totalCost) ];