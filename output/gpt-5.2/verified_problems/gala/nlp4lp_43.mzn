% Steel blending / foundry profit maximization
% Data is provided via .dzn

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
int: K;                              % number of minerals
float: SteelQuantity;                % tons of steel to produce

float: ManganesePercent;             % required minimum Mn percentage in final steel
float: SiliconMinPercent;            % required minimum Si percentage
float: SiliconMaxPercent;            % allowed maximum Si percentage

array[1..K] of float: SiliconContent;    % Si % in mineral k
array[1..K] of float: ManganeseContent;  % Mn % in mineral k

float: ManganesePrice;               % $/ton of pure Mn added
array[1..K] of float: MaterialCost;  % $/ton of mineral k

float: SellingPrice;                 % $/ton of steel sold
float: MeltingPrice;                 % $/ton melted (per ton of mineral processed)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decision variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
array[1..K] of var float: x;          % tons of each mineral used
var float: mn_add;                   % tons of pure Mn added

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constraint forall(k in 1..K)(x[k] >= 0.0);
constraint mn_add >= 0.0;

% Mass balance: minerals + added Mn = total steel
constraint sum(k in 1..K)(x[k]) + mn_add = SteelQuantity;

% Composition constraints (percentages are on steel mass basis)
% Convert % to fraction of total steel mass:
constraint sum(k in 1..K)( (SiliconContent[k] / 100.0) * x[k] )
          >= (SiliconMinPercent / 100.0) * SteelQuantity;

constraint sum(k in 1..K)( (SiliconContent[k] / 100.0) * x[k] )
          <= (SiliconMaxPercent / 100.0) * SteelQuantity;

constraint sum(k in 1..K)( (ManganeseContent[k] / 100.0) * x[k] ) + mn_add
          >= (ManganesePercent / 100.0) * SteelQuantity;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objective: maximize profit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var float: revenue = SellingPrice * SteelQuantity;

var float: material_cost = sum(k in 1..K)(MaterialCost[k] * x[k]);
var float: mn_cost = ManganesePrice * mn_add;
var float: melting_cost = MeltingPrice * sum(k in 1..K)(x[k]); % smelting per ton of mineral

var float: profit = revenue - material_cost - mn_cost - melting_cost;

solve maximize profit;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output [
  "x (tons per mineral) = ", show(x), "\n",
  "mn_add (tons)        = ", show(mn_add), "\n",
  "revenue             = ", show(revenue), "\n",
  "material_cost       = ", show(material_cost), "\n",
  "mn_cost             = ", show(mn_cost), "\n",
  "melting_cost        = ", show(melting_cost), "\n",
  "profit              = ", show(profit), "\n"
];