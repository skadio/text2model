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

array[1..K] of var float: amount;
var float: manganese_added;

constraint sum(i in 1..K)(amount[i]) + manganese_added = SteelQuantity;

constraint sum(i in 1..K)(amount[i] * SiliconContent[i]) / SteelQuantity >= SiliconMinPercent;
constraint sum(i in 1..K)(amount[i] * SiliconContent[i]) / SteelQuantity <= SiliconMaxPercent;

constraint (sum(i in 1..K)(amount[i] * ManganeseContent[i]) + manganese_added) / SteelQuantity >= ManganesePercent;

constraint forall(i in 1..K)(amount[i] >= 0);
constraint manganese_added >= 0;

var float: profit = SteelQuantity * (SellingPrice - MeltingPrice) - sum(i in 1..K)(amount[i] * MaterialCost[i]) - manganese_added * ManganesePrice;

solve maximize profit;

output [
  "Profit: ", show(profit), "\n",
  "Manganese added: ", show(manganese_added), "\n",
  "Mineral amounts: ", show(amount), "\n"
];