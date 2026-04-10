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

array[MINERALS] of var float: x;
var float: y;

var float: profit;

constraint forall(k in MINERALS) (x[k] >= 0.0);
constraint y >= 0.0;

constraint sum(k in MINERALS)(x[k]) + y = SteelQuantity;

constraint sum(k in MINERALS)(ManganeseContent[k] * x[k]) + y
          >= (ManganesePercent / 100.0) * SteelQuantity;

constraint sum(k in MINERALS)(SiliconContent[k] * x[k])
          >= (SiliconMinPercent / 100.0) * SteelQuantity;

constraint sum(k in MINERALS)(SiliconContent[k] * x[k])
          <= (SiliconMaxPercent / 100.0) * SteelQuantity;

constraint profit =
    SellingPrice * SteelQuantity
  - sum(k in MINERALS)(MaterialCost[k] * x[k])
  - ManganesePrice * y
  - MeltingPrice * SteelQuantity;

solve maximize profit;