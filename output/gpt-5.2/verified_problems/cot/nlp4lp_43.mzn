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
array[MINERALS] of var float: x;     % tons of mineral k used
var float: y;                        % tons of pure manganese added

var float: profit;

% Constraints
constraint forall(k in MINERALS) (x[k] >= 0.0);
constraint y >= 0.0;

% Total steel quantity balance (minerals + added Mn)
constraint sum(k in MINERALS)(x[k]) + y = SteelQuantity;

% Manganese minimum requirement
constraint
  (sum(k in MINERALS)(ManganeseContent[k] * x[k]) + 100.0 * y)
  >= (ManganesePercent * SteelQuantity);

% Silicon bounds
constraint
  sum(k in MINERALS)(SiliconContent[k] * x[k])
  >= (SiliconMinPercent * SteelQuantity);

constraint
  sum(k in MINERALS)(SiliconContent[k] * x[k])
  <= (SiliconMaxPercent * SteelQuantity);

% Profit definition
constraint
  profit =
    SellingPrice * SteelQuantity
    - (sum(k in MINERALS)(MaterialCost[k] * x[k]) + ManganesePrice * y)
    - (MeltingPrice * SteelQuantity);

% Objective
solve maximize profit;