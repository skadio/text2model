int: K;
set of int: Mineral = 1..K;

float: SteelQuantity;
float: ManganesePercent;
float: SiliconMinPercent;
float: SiliconMaxPercent;

array[Mineral] of float: SiliconContent;
array[Mineral] of float: ManganeseContent;

float: ManganesePrice;
array[Mineral] of float: MaterialCost;

float: SellingPrice;
float: MeltingPrice;

array[Mineral] of var 0.0..SteelQuantity: Qty;
var 0.0..SteelQuantity: MnAdd;
var float: Profit;

constraint
    sum(m in Mineral)(Qty[m]) + MnAdd = SteelQuantity;

constraint
    sum(m in Mineral)(Qty[m] * ManganeseContent[m] / 100.0) + MnAdd
        >= ManganesePercent / 100.0 * SteelQuantity;

constraint
    SiliconMinPercent / 100.0 * SteelQuantity
        <= sum(m in Mineral)(Qty[m] * SiliconContent[m] / 100.0);

constraint
    sum(m in Mineral)(Qty[m] * SiliconContent[m] / 100.0)
        <= SiliconMaxPercent / 100.0 * SteelQuantity;

constraint
    Profit =
        SellingPrice * SteelQuantity
        - (
            sum(m in Mineral)(Qty[m] * (MaterialCost[m] + MeltingPrice))
            + MnAdd * (ManganesePrice + MeltingPrice)
          );

solve maximize Profit;