include "globals.mzn";

/* Data parameters */
int: K;
float: SteelQuantity;
float: ManganesePercent;
float: SiliconMinPercent;
float: SiliconMaxPercent;
array[1..K] of float: SiliconContent;
array[1..K] of float: ManganeseContent;
float: ManganesePrice;
array[1..K] of float: MaterialCost;
float: SellingPrice;
float: MeltingPrice;

/* Decision variables: 
   x[i] = tons of mineral type i used in the mix 
   y = tons of pure manganese added */
array[1..K] of var 0.0..SteelQuantity: x;
var 0.0..SteelQuantity: y;

/* Constraint: Total produced steel must equal the order */
constraint sum(i in 1..K)(x[i]) + y = SteelQuantity;

/* Constraint: Manganese composition requirement.
   Each mineral i contributes ManganeseContent[i]*x[i] while pure manganese (y) is 100% manganese. */
constraint sum(i in 1..K)(ManganeseContent[i] * x[i]) + y >= ManganesePercent * SteelQuantity;

/* Constraint: Silicon composition requirement.
   Only the minerals contribute silicon. */
var float: totalSilicon = sum(i in 1..K)(SiliconContent[i] * x[i]);
constraint SiliconMinPercent * SteelQuantity <= totalSilicon;
constraint totalSilicon <= SiliconMaxPercent * SteelQuantity;

/* Objective: Maximize profit.
   Revenue = SellingPrice * SteelQuantity.
   Costs: melting cost, mineral purchase cost, and pure manganese purchase cost.
   Note that SteelQuantity and melting cost are fixed once SteelQuantity is given.
*/
var float: profit = SellingPrice * SteelQuantity - (MeltingPrice * SteelQuantity + sum(i in 1..K)(MaterialCost[i] * x[i]) + ManganesePrice * y);

solve maximize profit;

output [
  "Mineral usage (tons): ", show(x), "\n",
  "Added pure manganese (tons): ", show(y), "\n",
  "Achieved Profit: ", show(profit), "\n"
];