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
var 0.0..SteelQuantity: ManganeseAdded; % Amount of manganese added
array[1..K] of var 0.0..SteelQuantity: MineralsUsed; % Amount of each mineral used

% Constraints
% The total amount of minerals used and manganese added should be equal to the steel quantity
constraint sum(MineralsUsed) + ManganeseAdded = SteelQuantity;

% The manganese content in the steel should be at least the required percentage
constraint sum([MineralsUsed[i]*ManganeseContent[i] | i in 1..K]) + ManganeseAdded >= ManganesePercent * SteelQuantity;

% The silicon content in the steel should be within the required range
constraint sum([MineralsUsed[i]*SiliconContent[i] | i in 1..K]) >= SiliconMinPercent * SteelQuantity;
constraint sum([MineralsUsed[i]*SiliconContent[i] | i in 1..K]) <= SiliconMaxPercent * SteelQuantity;

% Objective
% The objective is to maximize the profit
solve maximize SellingPrice*SteelQuantity - sum([MineralsUsed[i]*MaterialCost[i] | i in 1..K]) - ManganeseAdded*ManganesePrice - MeltingPrice*SteelQuantity;