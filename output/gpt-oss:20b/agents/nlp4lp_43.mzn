%  Steel Production Profit Maximisation
%  =====================================

%--- Data -------------------------------------------------
int: K;                                 % number of mineral types
int: SteelQuantity;                     % total steel to produce (tons)
float: ManganesePercent;                % required minimum % Mn
float: SiliconMinPercent;               % minimum % Si
float: SiliconMaxPercent;               % maximum % Si
array[1..K] of float: SiliconContent;   % % Si in each mineral
array[1..K] of float: ManganeseContent; % % Mn in each mineral
float: ManganesePrice;                  % price per ton of Mn (direct)
array[1..K] of float: MaterialCost;     % price per ton of each mineral
float: SellingPrice;                    % selling price per ton of steel
float: MeltingPrice;                    % melting cost per ton of steel

%--- Decision variables -----------------------------------
array[1..K] of var float: x;   % tons of each mineral used
var float: y;                  % tons of direct manganese added

%--- Derived variable -------------------------------------
var float: profit = 
      SteelQuantity * SellingPrice
    - ( sum(x[i] * MaterialCost[i] | i in 1..K) + y * ManganesePrice
        + SteelQuantity * MeltingPrice );

%--- Constraints ------------------------------------------
constraint sum(x) + y == SteelQuantity;

constraint sum(x[i] * SiliconContent[i] | i in 1..K)
          >= SiliconMinPercent * SteelQuantity;
constraint sum(x[i] * SiliconContent[i] | i in 1..K)
          <= SiliconMaxPercent * SteelQuantity;

constraint sum(x[i] * ManganeseContent[i] | i in 1..K) + y
          >= ManganesePercent * SteelQuantity;

constraint forall(i in 1..K)(x[i] >= 0);
constraint y >= 0;

%--- Solve ------------------------------------------------
solve maximize profit;

%--- Output ------------------------------------------------
output [
  "Profit = ", show(profit), "\n",
  "Minerals used (tons): ", show(x), "\n",
  "Direct manganese added (tons): ", show(y), "\n"
];