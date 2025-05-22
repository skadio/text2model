% Parameters
int: M;
int: I;

set of int: Months  = 1..M;
set of int: Oils    = 1..I;
set of int: Periods = 0..M;                     % for inventory balance (month 0 .. M)

array[Months, Oils] of float: BuyPrice;         % price to buy oil i in month m
float: SellPrice;                               % selling price of final product (per ton)

array[Oils] of bool:  IsVegetable;              % true if oil is vegetable
int:  MaxVegetableRefiningPerMonth;
int:  MaxNonVegetableRefiningPerMonth;

int:  StorageSize;                              % maximum total inventory (tons)
float: StorageCost;                             % cost per ton stored per month

float: MaxHardness;                             % technological hardness limits
float: MinHardness;
array[Oils] of float: Hardness;                 % hardness of each oil

array[Oils] of float: InitialAmount;            % initial inventory of each oil (tons)


% Helpful constants
float: StorageSizeF      = float(StorageSize);
float: VegCapF           = float(MaxVegetableRefiningPerMonth);
float: NonVegCapF        = float(MaxNonVegetableRefiningPerMonth);
float: MaxRefineCapacity = max(VegCapF, NonVegCapF);

% Decision variables
array[Periods, Oils] of var 0.0..StorageSizeF: Store;             % inventory at end of period p
array[Months,  Oils] of var 0.0..StorageSizeF: Buy;               % tons bought in month m
array[Months,  Oils] of var 0.0..MaxRefineCapacity: Refine;       % tons refined in month m


% 1. Initial and final inventory requirements
constraint forall(i in Oils)(
    Store[0,i] = InitialAmount[i]
);
constraint forall(i in Oils)(
    Store[M,i] = InitialAmount[i]
);

% 2. Inventory balance
constraint
    forall(m in Months, i in Oils)(
        Store[m,i] = Store[m-1,i] + Buy[m,i] - Refine[m,i]
    );

% 3. Storage capacity limit
constraint
    forall(p in Periods)(
        sum(i in Oils)(Store[p,i]) <= StorageSizeF
    );

% 4. Refining capacity per month
constraint
    forall(m in Months)(
        sum(i in Oils where IsVegetable[i])(Refine[m,i]) <= VegCapF
    );
constraint
    forall(m in Months)(
        sum(i in Oils where not IsVegetable[i])(Refine[m,i]) <= NonVegCapF
    );

% 5. Hardness constraints for the monthly blend
constraint
    forall(m in Months)(
        sum(i in Oils)(Hardness[i] * Refine[m,i]) >= MinHardness * sum(i in Oils)(Refine[m,i])
    );
constraint
    forall(m in Months)(
        sum(i in Oils)(Hardness[i] * Refine[m,i]) <= MaxHardness * sum(i in Oils)(Refine[m,i])
    );

% Objective components
var float: TotalRevenue     = SellPrice * sum(m in Months, i in Oils)(Refine[m,i]);
var float: TotalBuyingCost  = sum(m in Months, i in Oils)(BuyPrice[m,i] * Buy[m,i]);
var float: TotalStorageCost = StorageCost * sum(m in Months, i in Oils)(Store[m,i]);

var float: Profit = TotalRevenue - TotalBuyingCost - TotalStorageCost;

solve maximize Profit;