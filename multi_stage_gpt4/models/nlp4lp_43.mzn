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
var 0.0..SteelQuantity: manganese_added; % Amount of manganese added to the steel
array[1..K] of var 0.0..SteelQuantity: minerals_used; % Amount of each mineral used in the steel

% Constraints

% The total quantity of steel produced should be equal to the sum of the quantities of minerals used and manganese added
constraint sum(minerals_used) + manganese_added = SteelQuantity;

% The manganese content in the steel should be at least the required percentage
constraint sum([minerals_used[k]*ManganeseContent[k] | k in 1..K]) + manganese_added*ManganesePercent >= SteelQuantity*ManganesePercent;

% The silicon content in the steel should be within the required range
constraint sum([minerals_used[k]*SiliconContent[k] | k in 1..K]) >= SteelQuantity*SiliconMinPercent;
constraint sum([minerals_used[k]*SiliconContent[k] | k in 1..K]) <= SteelQuantity*SiliconMaxPercent;

% The cost of producing the steel should not exceed the selling price
constraint sum([minerals_used[k]*MaterialCost[k] | k in 1..K]) + manganese_added*ManganesePrice + SteelQuantity*MeltingPrice <= SteelQuantity*SellingPrice;

% Objective
solve maximize SteelQuantity*SellingPrice - sum([minerals_used[k]*MaterialCost[k] | k in 1..K]) - manganese_added*ManganesePrice - SteelQuantity*MeltingPrice;