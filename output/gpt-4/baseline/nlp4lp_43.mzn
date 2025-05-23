include "globals.mzn";

% Parameters
int: K;
int: SteelQuantity;
float: ManganesePercent;
float: SiliconMinPercent;
float: SiliconMaxPercent;
array[1..K] of float: SiliconContent;
array[1..K] of float: ManganeseContent;
float: ManganesePrice;
array[1..K] of float: MaterialCost;
float: SellingPrice;
float: MeltingPrice;

% Decision Variables
var float: manganese_added;
array[1..K] of var 0..SteelQuantity: minerals_used;

% Objective Function
var float: profit = SellingPrice * SteelQuantity - MeltingPrice * SteelQuantity - ManganesePrice * manganese_added - sum(i in 1..K)(minerals_used[i] * MaterialCost[i]);
maximize profit;

% Constraints
constraint sum(i in 1..K)(minerals_used[i] * SiliconContent[i]) / SteelQuantity >= SiliconMinPercent;
constraint sum(i in 1..K)(minerals_used[i] * SiliconContent[i]) / SteelQuantity <= SiliconMaxPercent;
constraint sum(i in 1..K)(minerals_used[i] * ManganeseContent[i]) + manganese_added >= ManganesePercent * SteelQuantity;
constraint sum(i in 1..K)(minerals_used[i]) + manganese_added = SteelQuantity;

solve satisfy;