include "globals.mzn";

% Foods: 1 Chicken, 2 Oats, 3 Tofu, 4 Rice, 5 Beef, 6 Salmon
int: n = 6;
set of int: FOODS = 1..n;

array[FOODS] of int: protein = [14, 11, 8, 1, 16, 19];
array[FOODS] of int: carbs   = [ 1,  6,12,17, 11, 13];
array[FOODS] of int: cal     = [164,210,98,92,211,211];
array[FOODS] of int: cost    = [ 6,  2, 9, 3,  7,  9];

int: reqP = 70;
int: reqC = 117;
int: reqK = 1837;

% Upper bound sufficient for feasibility (tight enough for search)
int: maxUnits = 200;

array[FOODS] of var 0..maxUnits: x;

constraint sum(i in FOODS)(protein[i] * x[i]) >= reqP;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= reqC;
constraint sum(i in FOODS)(cal[i]     * x[i]) >= reqK;

var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [ show(totalCost) ];