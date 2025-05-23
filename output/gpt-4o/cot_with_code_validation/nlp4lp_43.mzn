% Parameters
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

% Variables
array[MINERALS] of var 0.0..SteelQuantity: useMineral;   % tons of each mineral
var 0.0..SteelQuantity: addManganese;                    % tons of pure manganese added

% Constraints
constraint
    sum(i in MINERALS)(useMineral[i]) + addManganese = SteelQuantity;

constraint
    sum(i in MINERALS)(useMineral[i] * ManganeseContent[i])
    + 100.0 * addManganese
    >= ManganesePercent * SteelQuantity;

constraint
    sum(i in MINERALS)(useMineral[i] * SiliconContent[i])
    >= SiliconMinPercent * SteelQuantity;

constraint
    sum(i in MINERALS)(useMineral[i] * SiliconContent[i])
    <= SiliconMaxPercent * SteelQuantity;

% Objective
var float: profit =
        SellingPrice * SteelQuantity
      - ( sum(i in MINERALS)(useMineral[i] * MaterialCost[i])
          + addManganese * ManganesePrice
          + MeltingPrice * SteelQuantity );

solve maximize profit;