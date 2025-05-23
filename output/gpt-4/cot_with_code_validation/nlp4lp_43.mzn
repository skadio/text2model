% Parameters
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

% Variables
var 0.0..SteelQuantity: manganese_added;
array[1..K] of var 0.0..SteelQuantity: minerals_used;

% Constraints
constraint sum(minerals_used) + manganese_added = SteelQuantity;
constraint sum([minerals_used[i]*ManganeseContent[i] | i in 1..K]) + manganese_added*ManganesePercent >= SteelQuantity*ManganesePercent;
constraint sum([minerals_used[i]*SiliconContent[i] | i in 1..K]) >= SteelQuantity*SiliconMinPercent;
constraint sum([minerals_used[i]*SiliconContent[i] | i in 1..K]) <= SteelQuantity*SiliconMaxPercent;

% Objective
var float: total_cost = sum([minerals_used[i]*MaterialCost[i] | i in 1..K]) + manganese_added*ManganesePrice + (SteelQuantity*MeltingPrice);
var float: total_revenue = SteelQuantity*SellingPrice;
var float: profit = total_revenue - total_cost;
solve maximize profit;