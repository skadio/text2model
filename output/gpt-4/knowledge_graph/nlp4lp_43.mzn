include "globals.mzn";

% Parameters
int: K; % Number of types of minerals
int: SteelQuantity; % Amount of steel to produce in tons
float: ManganesePercent; % Percentage of manganese in the steel required
float: SiliconMinPercent; % Minimum percentage of silicon in the steel required
float: SiliconMaxPercent; % Maximum percentage of silicon in the steel allowed
array[1..K] of float: SiliconContent; % Silicon content in the k-th stock
array[1..K] of float: ManganeseContent; % Manganese content in the k-th stock
float: ManganesePrice; % Price of manganese per ton
array[1..K] of float: MaterialCost; % Cost of the k-th stock material per ton
float: SellingPrice; % Selling price of steel per ton
float: MeltingPrice; % Price to melt one ton of steel

% Variables
var 0..SteelQuantity: manganese_added; % Amount of manganese added
array[1..K] of var 0..SteelQuantity: minerals_used; % Amount of each mineral used

% Constraints
constraint sum(minerals_used) + manganese_added = SteelQuantity;
constraint sum(minerals_used[i]*SiliconContent[i] for i in 1..K) / SteelQuantity >= SiliconMinPercent;
constraint sum(minerals_used[i]*SiliconContent[i] for i in 1..K) / SteelQuantity <= SiliconMaxPercent;
constraint sum(minerals_used[i]*ManganeseContent[i] for i in 1..K) + manganese_added / SteelQuantity >= ManganesePercent;

% Objective
var float: profit = SellingPrice * SteelQuantity - MeltingPrice * SteelQuantity - ManganesePrice * manganese_added - sum(MaterialCost[i] * minerals_used[i] for i in 1..K);
solve maximize profit;

% Output
output ["Profit: ", show(profit), "\nMinerals used: ", show(minerals_used), "\nManganese added: ", show(manganese_added)];