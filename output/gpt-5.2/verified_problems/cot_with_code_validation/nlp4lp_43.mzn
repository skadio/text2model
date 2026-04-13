% Foundry steel blending - maximize profit

% --------------------
% Parameters (given in .dzn)
% --------------------
int: K;
set of int: MINERALS = 1..K;

float: SteelQuantity;

float: ManganesePercent;     % in percent units (e.g., 0.45 means 0.45%)
float: SiliconMinPercent;    % in percent units
float: SiliconMaxPercent;    % in percent units

array[MINERALS] of float: SiliconContent;     % in percent units per ton mineral
array[MINERALS] of float: ManganeseContent;   % in percent units per ton mineral

float: ManganesePrice;                 % price per ton of pure Mn
array[MINERALS] of float: MaterialCost; % price per ton of mineral

float: SellingPrice;   % selling price per ton of steel
float: MeltingPrice;   % melting cost per ton of (input/steel), taken per ton steel

% --------------------
% Decision variables
% --------------------
array[MINERALS] of var float: x;   % tons of each mineral used
var float: addMn;                  % tons of pure manganese added

var float: profit;

% --------------------
% Constraints
% --------------------
constraint forall(k in MINERALS) (x[k] >= 0.0);
constraint addMn >= 0.0;

% Total mass balance
constraint sum(k in MINERALS)(x[k]) + addMn = SteelQuantity;

% Manganese requirement (at least required percentage of final steel)
constraint
  sum(k in MINERALS)( (ManganeseContent[k] / 100.0) * x[k] ) + addMn
  >= (ManganesePercent / 100.0) * SteelQuantity;

% Silicon bounds (percentage of final steel)
constraint
  sum(k in MINERALS)( (SiliconContent[k] / 100.0) * x[k] )
  >= (SiliconMinPercent / 100.0) * SteelQuantity;

constraint
  sum(k in MINERALS)( (SiliconContent[k] / 100.0) * x[k] )
  <= (SiliconMaxPercent / 100.0) * SteelQuantity;

% Profit definition: revenue - mineral purchase - Mn purchase - melting cost
constraint
  profit =
    SellingPrice * SteelQuantity
    - sum(k in MINERALS)(MaterialCost[k] * x[k])
    - ManganesePrice * addMn
    - MeltingPrice * SteelQuantity;

% --------------------
% Objective
% --------------------
solve maximize profit;