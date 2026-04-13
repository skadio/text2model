int: K;
set of int: MINERALS = 1..K;

float: SteelQuantity;

float: ManganesePercent;
float: SiliconMinPercent;
float: SiliconMaxPercent;

array[MINERALS] of float: SiliconContent;
array[MINERALS] of float: ManganeseContent;

float: ManganesePrice;
array[MINERALS] of float: MaterialCost;

float: SellingPrice;
float: MeltingPrice;

var float: addedMn;                       % tons of pure manganese added
array[MINERALS] of var float: x;          % tons of each mineral used

constraint forall(k in MINERALS) (x[k] >= 0.0);
constraint addedMn >= 0.0;

% Mass balance (minerals + added manganese = steel produced)
constraint sum(k in MINERALS)(x[k]) + addedMn = SteelQuantity;

% Composition constraints (percentages are per ton; divide by total steel)
constraint sum(k in MINERALS)(ManganeseContent[k] * x[k]) + 1.0 * addedMn
          >= (ManganesePercent / 100.0) * SteelQuantity;

constraint sum(k in MINERALS)(SiliconContent[k] * x[k])
          >= (SiliconMinPercent / 100.0) * SteelQuantity;

constraint sum(k in MINERALS)(SiliconContent[k] * x[k])
          <= (SiliconMaxPercent / 100.0) * SteelQuantity;

% Profit = revenue - (material + manganese + melting) costs
var float: revenue = SellingPrice * SteelQuantity;
var float: totalMaterialCost = sum(k in MINERALS)(MaterialCost[k] * x[k]);
var float: totalMnCost = ManganesePrice * addedMn;
var float: totalMeltingCost = MeltingPrice * SteelQuantity;

var float: profit = revenue - totalMaterialCost - totalMnCost - totalMeltingCost;

solve maximize profit;

output [
  "profit = ", show(profit), "\n",
  "addedMn = ", show(addedMn), "\n",
  "x = ", show(x), "\n",
  "revenue = ", show(revenue), "\n",
  "materialCost = ", show(totalMaterialCost), "\n",
  "manganeseCost = ", show(totalMnCost), "\n",
  "meltingCost = ", show(totalMeltingCost), "\n"
];