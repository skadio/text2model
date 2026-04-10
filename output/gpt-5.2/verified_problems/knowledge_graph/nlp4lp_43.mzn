int: K;
set of int: MINERALS = 1..K;

float: SteelQuantity;
float: ManganesePercent;
float: SiliconMinPercent;
float: SiliconMaxPercent;

array[MINERALS] of float: SiliconContent;     % percent (same units as SiliconMin/Max)
array[MINERALS] of float: ManganeseContent;   % percent (same units as ManganesePercent)

float: ManganesePrice;                        % cost per ton of added pure Mn
array[MINERALS] of float: MaterialCost;       % cost per ton of mineral
float: SellingPrice;                          % revenue per ton of steel
float: MeltingPrice;                          % cost per ton processed (assumed per ton of steel)

% Decision variables
array[MINERALS] of var float: x;              % tons of each mineral used
var float: addMn;                             % tons of pure manganese added

% Mass balance: total steel produced equals total inputs
constraint sum(m in MINERALS)(x[m]) + addMn = SteelQuantity;

% Composition constraints (percent-by-weight; use *100 to match percent units)
constraint
  100.0 * (sum(m in MINERALS)(x[m] * (ManganeseContent[m] / 100.0)) + addMn)
  >= ManganesePercent * SteelQuantity;

constraint
  100.0 * sum(m in MINERALS)(x[m] * (SiliconContent[m] / 100.0))
  >= SiliconMinPercent * SteelQuantity;

constraint
  100.0 * sum(m in MINERALS)(x[m] * (SiliconContent[m] / 100.0))
  <= SiliconMaxPercent * SteelQuantity;

% Non-negativity
constraint forall(m in MINERALS)(x[m] >= 0.0);
constraint addMn >= 0.0;

% Objective: maximize profit = revenue - (material + added Mn + melting)
var float: revenue = SellingPrice * SteelQuantity;
var float: cost_materials = sum(m in MINERALS)(MaterialCost[m] * x[m]);
var float: cost_mn = ManganesePrice * addMn;
var float: cost_melting = MeltingPrice * SteelQuantity;

var float: profit = revenue - (cost_materials + cost_mn + cost_melting);

solve maximize profit;

output [
  "profit = ", show(profit), "\n",
  "x = ", show(x), "\n",
  "addMn = ", show(addMn), "\n",
  "revenue = ", show(revenue), "\n",
  "cost_materials = ", show(cost_materials), "\n",
  "cost_mn = ", show(cost_mn), "\n",
  "cost_melting = ", show(cost_melting), "\n"
];