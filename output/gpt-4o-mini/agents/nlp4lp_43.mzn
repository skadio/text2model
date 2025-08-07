int: K;                          % Number of types of minerals
int: SteelQuantity;              % Amount of steel to produce in tons
float: ManganesePercent;         % Percentage of manganese in the steel required
float: SiliconMinPercent;        % Minimum percentage of silicon in the steel required
float: SiliconMaxPercent;        % Maximum percentage of silicon in the steel allowed
array[1..K] of float: SiliconContent;  % Silicon content in the k-th stock
array[1..K] of float: ManganeseContent; % Manganese content in the k-th stock
float: ManganesePrice;           % Price of manganese per ton
array[1..K] of float: MaterialCost; % Cost of the k-th stock material per ton
float: SellingPrice;             % Selling price of steel per ton
float: MeltingPrice;             % Price to melt one ton of steel

/* Decision variables */
array[1..K] of var nonneg_real: mineralAmount; % Amount of each mineral to use
var nonneg_real: manganeseAdded;                % Amount of manganese added directly

/* Constraints */
% Total amount of steel produced
constraint sum(mineralAmount) + manganeseAdded = SteelQuantity;

% Calculate the total manganese and silicon content
var float: totalManganese = sum(i in 1..K)(ManganeseContent[i] * mineralAmount[i]) + manganeseAdded;
var float: totalSilicon = sum(i in 1..K)(SiliconContent[i] * mineralAmount[i]);

% Manganese and silicon percentage constraints
constraint totalManganese / SteelQuantity >= ManganesePercent;
constraint totalSilicon / SteelQuantity >= SiliconMinPercent;
constraint totalSilicon / SteelQuantity <= SiliconMaxPercent;

/* Objective function: Maximize profit */
var float: totalCost = sum(i in 1..K)(MaterialCost[i] * mineralAmount[i]) + (ManganesePrice * manganeseAdded) + (MeltingPrice * SteelQuantity);
var float: totalRevenue = SellingPrice * SteelQuantity;
var float: profit = totalRevenue - totalCost;

solve maximize profit;

/* Output */
output [ "Mineral Amounts = ", show(mineralAmount), "\n",
         "Manganese Added = ", show(manganeseAdded), "\n",
         "Total Profit = ", show(profit), "\n" ];