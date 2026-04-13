include "globals.mzn";

/* Data (embedded from problem statement) */
int: total_area = 120;

int: p_apples  = 2000;
int: p_pears   = 1800;
int: p_oranges = 2200;
int: p_lemons  = 3000;

/* Decision variables: acres of each fruit (integer acres) */
var 0..total_area: apples;
var 0..total_area: pears;
var 0..total_area: oranges;
var 0..total_area: lemons;

/* At most two types of fruit grown */
var 0..1: growA;
var 0..1: growP;
var 0..1: growO;
var 0..1: growL;

/* Link acreage to whether the fruit is grown */
constraint (apples  > 0) <-> (growA = 1);
constraint (pears   > 0) <-> (growP = 1);
constraint (oranges > 0) <-> (growO = 1);
constraint (lemons  > 0) <-> (growL = 1);

constraint growA + growP + growO + growL <= 2;

/* Total land limit */
constraint apples + pears + oranges + lemons <= total_area;

/* Agronomic/ratio constraints */
constraint apples >= 2 * pears;
constraint apples >= 3 * lemons;
constraint oranges = 2 * lemons;

/* Objective: maximize profit */
var int: profit =
  p_apples  * apples +
  p_pears   * pears +
  p_oranges * oranges +
  p_lemons  * lemons;

solve maximize profit;

output [
  "apples_acres  = ", show(apples),  "\n",
  "pears_acres   = ", show(pears),   "\n",
  "oranges_acres = ", show(oranges), "\n",
  "lemons_acres  = ", show(lemons),  "\n",
  "profit        = ", show(profit),  "\n",
  "types_grown   = ", show(growA + growP + growO + growL), "\n"
];