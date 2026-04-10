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
var float: addMn;

var float: profit;

constraint forall(k in MINERALS) (x[k] >= 0.0);
constraint addMn >= 0.0;

constraint sum(k in MINERALS)(x[k]) + addMn = SteelQuantity;

constraint sum(k in MINERALS)((ManganeseContent[k] / 100.0) * x[k]) + addMn
        >= (ManganesePercent / 100.0) * SteelQuantity;

constraint sum(k in MINERALS)((SiliconContent[k] / 100.0) * x[k])
        >= (SiliconMinPercent / 100.0) * SteelQuantity;

constraint sum(k in MINERALS)((SiliconContent[k] / 100.0) * x[k])
        <= (SiliconMaxPercent / 100.0) * SteelQuantity;

constraint profit =
    SellingPrice * SteelQuantity
  - ( sum(k in MINERALS)((MaterialCost[k] + MeltingPrice) * x[k])
      + (ManganesePrice + MeltingPrice) * addMn );

solve maximize profit;

output [
  "profit=", show(profit), "\n",
  "addMn=", show(addMn), "\n",
  "x=", show(x), "\n"
];