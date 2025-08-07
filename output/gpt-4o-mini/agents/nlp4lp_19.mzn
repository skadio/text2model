include "globals.mzn";

int: M;                          % Number of months
int: I;                          % Number of different oils
array[1..M, 1..I] of int: BuyPrice; % Buy price of oil i in month m
int: SellPrice;                 % Sell price of the products after refining
array[1..I] of bool: IsVegetable; % Indicator whether item i is a vegetable oil
int: MaxVegetableRefiningPerMonth; % Total refining capability for vegetable oils per month
int: MaxNonVegetableRefiningPerMonth; % Total refining capability for non-vegetable oils per month
int: StorageSize;               % Storage capacity for raw oil
int: StorageCost;               % Cost for storing oil per month per ton
int: MaxHardness;               % The maximum hardness allowed for the products after refining
int: MinHardness;               % The minimum hardness required for the products after refining
array[1..I] of float: Hardness; % Hardness of item i
int: InitialAmount;             % Initial amount of items in storage at the beginning of the planning horizon

/* Decision Variables */
array[1..M, 1..I] of var 0..StorageSize: BuyAmount; % Amount of oil i bought in month m
array[1..M, 1..I] of var 0..StorageSize: StoreAmount; % Amount of oil i stored at the end of month m
array[1..M, 1..I] of var 0..StorageSize: RefineAmount; % Amount of oil i refined in month m
var 0..StorageSize: TotalStorage; % Total storage at the end of the last month

/* Constraints */
% Storage constraints
constraint forall(m in 1..M)(
    forall(i in 1..I)(
        StoreAmount[m, i] = 
            if m == 1 then InitialAmount
            else StoreAmount[m-1, i] + BuyAmount[m, i] - RefineAmount[m, i]
        endif
    )
);

% Ensure storage does not exceed capacity
constraint forall(m in 1..M)(
    sum(i in 1..I)(StoreAmount[m, i]) <= StorageSize
);

% Refining constraints
constraint forall(m in 1..M)(
    sum(i in 1..I where IsVegetable[i])(RefineAmount[m, i]) <= MaxVegetableRefiningPerMonth /\
    sum(i in 1..I where not IsVegetable[i])(RefineAmount[m, i]) <= MaxNonVegetableRefiningPerMonth
);

/* Hardness constraints */
var float: FinalHardness = sum(i in 1..I)(RefineAmount[M, i] * Hardness[i]) / sum(i in 1..I)(RefineAmount[M, i]);
constraint FinalHardness >= MinHardness /\ FinalHardness <= MaxHardness;

/* Objective Function: Maximize profit */
var int: Profit = SellPrice * sum(i in 1..I)(RefineAmount[M, i]) - 
                  sum(m in 1..M)(sum(i in 1..I)(StorageCost * StoreAmount[m, i]));

solve maximize Profit;

/* Output */
output [
    "Total Profit = ", show(Profit), "\n",
    "Final Storage = ", show(StoreAmount[M, 1..I]), "\n"
];