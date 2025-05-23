% Parameters
int: I;
int: M;

set of int: OILS   = 1..I;
set of int: MONTHS = 1..M;
set of int: MONTHS0 = 0..M;          % for inventories including month 0

array[MONTHS, OILS] of float: BuyPrice;        % price of oil i in month m  (m,i)
float: SellPrice;                              % selling price of final product

array[OILS] of bool: IsVegetable;              % true  -> vegetable oil
int: MaxVegRefiningPerMonth;
int: MaxNonVegRefiningPerMonth;

int: StorageSize;                              % total storage capacity
float: StorageCost;                            % storage cost per ton per month

float: MaxHardness;                            % technological upper bound
float: MinHardness;                            % technological lower bound
array[OILS] of float: Hardness;                % hardness of each oil

int: InitialAmount;                            % starting (and ending) stock per oil
int: MinUsage;                                 % minimum usage when an oil is used

array[OILS, OILS] of int: Dependencies;        % 1 => if i used then j must be used


% Derived constant
int: MaxCapacity = MaxVegRefiningPerMonth + MaxNonVegRefiningPerMonth;   % big-M for usage


% Variables
array[OILS, MONTHS]  of var 0..StorageSize: BuyQty;                      % tons bought
array[OILS, MONTHS]  of var 0..MaxCapacity: UseQty;                      % tons refined / used
array[OILS, MONTHS]  of var bool: UseFlag;                               % 1 if oil i used in month m
array[OILS, MONTHS0] of var 0..StorageSize: Stock;                       % inventory (month 0..M)

array[MONTHS] of var 0..MaxCapacity*I: TotalUse;                         % total refined each month
array[MONTHS] of var float: HardSum;                                     % Σ hardness*usage per month

var float: Profit;                                                       % objective


% Constraints
% Inventory initial and final levels
constraint forall(i in OILS)(
    Stock[i,0] = InitialAmount /\ Stock[i,M] = InitialAmount
);

% Material balance
constraint forall(i in OILS, m in MONTHS)(
    Stock[i,m-1] + BuyQty[i,m] - UseQty[i,m] = Stock[i,m]
);

% Storage capacity
constraint forall(m in MONTHS0)(
    sum(i in OILS)(Stock[i,m]) <= StorageSize
);

% Link usage quantities to indicator variables
constraint forall(i in OILS, m in MONTHS)(
    UseQty[i,m] >= MinUsage * bool2int(UseFlag[i,m]) /\
    UseQty[i,m] <= MaxCapacity * bool2int(UseFlag[i,m])
);

% At most three oils can be used each month
constraint forall(m in MONTHS)(
    sum(i in OILS)(bool2int(UseFlag[i,m])) <= 3
);

% Dependency constraints
constraint forall(m in MONTHS, i in OILS, j in OILS where Dependencies[i,j] = 1)(
    bool2int(UseFlag[i,m]) <= bool2int(UseFlag[j,m])
);

% Refining capacity limits
constraint forall(m in MONTHS)(
    sum(i in OILS where IsVegetable[i])    (UseQty[i,m]) <= MaxVegRefiningPerMonth /\
    sum(i in OILS where not IsVegetable[i])(UseQty[i,m]) <= MaxNonVegRefiningPerMonth
);

% Compute totals and hardness sums
constraint forall(m in MONTHS)(
    TotalUse[m] = sum(i in OILS)(UseQty[i,m]) /\
    HardSum[m]  = sum(i in OILS)(Hardness[i] * UseQty[i,m])
);

% Hardness bounds when anything is produced
constraint forall(m in MONTHS)(
    (TotalUse[m] > 0) -> (
        MinHardness * TotalUse[m] <= HardSum[m] /\
        HardSum[m] <= MaxHardness * TotalUse[m]
    )
);

% Profit definition
constraint Profit =
        sum(m in MONTHS)( SellPrice * TotalUse[m] )
      - sum(i in OILS, m in MONTHS)( BuyPrice[m,i] * BuyQty[i,m] )
      - sum(i in OILS, m in MONTHS)( StorageCost * Stock[i,m] );

% Objective
solve maximize Profit;