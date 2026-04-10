% Diet / nutrition cost minimization (all data embedded)

include "globals.mzn";

enum FOOD = {Chicken, Rice, Beans, Avocado};
array[FOOD] of int: cost   = [4, 4, 2, 4];
array[FOOD] of int: protein= [14, 5, 9, 10];
array[FOOD] of int: carbs  = [7, 13, 26, 14];
array[FOOD] of int: cal    = [208, 140, 280, 199];

int: reqP = 74;
int: reqC = 166;
int: reqK = 2210;

% Conservative upper bounds (enough to reach all requirements)
int: maxServ = 20;

array[FOOD] of var 0..maxServ: x;

constraint sum(f in FOOD)(protein[f] * x[f]) >= reqP;
constraint sum(f in FOOD)(carbs[f]   * x[f]) >= reqC;
constraint sum(f in FOOD)(cal[f]     * x[f]) >= reqK;

var int: totalCost = sum(f in FOOD)(cost[f] * x[f]);

solve minimize totalCost;

output [ show(totalCost) ];