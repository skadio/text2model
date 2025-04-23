% Parameters
int: K; % Number of types of minerals
float: SteelQuantity; % Amount of steel to produce in tons
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
var 0.0..SteelQuantity: steelProduced; % Amount of steel produced
array[1..K] of var 0.0..SteelQuantity: mineralsUsed; % Amount of each mineral used
var 0.0..SteelQuantity: manganeseAdded; % Amount of manganese added
var 0.0..SteelQuantity: totalCost; % Total cost of production
var 0.0..SteelQuantity: totalRevenue; % Total revenue from selling the steel
var 0.0..SteelQuantity: profit; % Profit from the production and sale of steel

% Constraints

% The total amount of steel produced should be equal to the sum of the minerals used and the manganese added
constraint steelProduced = sum(mineralsUsed) + manganeseAdded;

% The total cost of production should be equal to the sum of the cost of each mineral used, the cost of manganese added, and the cost of melting the steel
constraint totalCost = sum([mineralsUsed[i]*MaterialCost[i] | i in 1..K]) + manganeseAdded*ManganesePrice + steelProduced*MeltingPrice;

% The total revenue from selling the steel should be equal to the selling price times the amount of steel produced
constraint totalRevenue = SellingPrice * steelProduced;

% The profit from the production and sale of steel should be equal to the total revenue minus the total cost
constraint profit = totalRevenue - totalCost;

% The percentage of manganese in the steel should be at least the given percentage
constraint sum([mineralsUsed[i]*ManganeseContent[i] | i in 1..K]) + manganeseAdded >= ManganesePercent * steelProduced;

% The percentage of silicon in the steel should be between the given lower and upper limits
constraint sum([mineralsUsed[i]*SiliconContent[i] | i in 1..K]) >= SiliconMinPercent * steelProduced;
constraint sum([mineralsUsed[i]*SiliconContent[i] | i in 1..K]) <= SiliconMaxPercent * steelProduced;

% Objective
solve maximize profit;