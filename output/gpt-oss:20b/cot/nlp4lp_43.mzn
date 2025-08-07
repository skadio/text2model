% Parameters
int: K;
int: SteelQuantity;
float: ManganesePercent;
float: SiliconMinPercent;
float: SiliconMaxPercent;
array[1..K] of float: SiliconContent;
array[1..K] of float: ManganeseContent;
float: ManganesePrice;
array[1..K] of float: MaterialCost;
float: SellingPrice;
float: MeltingPrice;

% Variables
array[1..K] of var float: x;          % Tons of each mineral used
var float: y;                         % Tons of direct manganese added
var float: profit;                    % Total profit

% Constraints
constraint
    forall(k in 1..K) (
        x[k] >= 0
    ) /\ y >= 0;

constraint
    sum(k in 1..K) (x[k] * ManganeseContent[k]) + y >= SteelQuantity * ManganesePercent;

constraint
    sum(k in 1..K) (x[k] * SiliconContent[k]) >= SteelQuantity * SiliconMinPercent /\
    sum(k in 1..K) (x[k] * SiliconContent[k]) <= SteelQuantity * SiliconMaxPercent;

constraint
    profit = SteelQuantity * SellingPrice -
             (sum(k in 1..K) (x[k] * MaterialCost[k]) + y * ManganesePrice + SteelQuantity * MeltingPrice);

% Objective
solve maximize profit;