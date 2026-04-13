% Parameters
int: M; % Number of months
int: I; % Number of different oils

set of int: MONTHS = 1..M;
set of int: OILS   = 1..I;

% NOTE: Data must use MiniZinc booleans: true/false (not True/False).
array[MONTHS, OILS] of int: BuyPrice; % Buy price of oil i in month m
int: SellPrice; % Sell price per ton of final product

array[OILS] of bool: IsVegetable; % true if oil i is vegetable

int: MaxVegetableRefiningPerMonth;     % Total veg refining capacity per month (tons)
int: MaxNonVegetableRefiningPerMonth;  % Total non-veg refining capacity per month (tons)

int: StorageSize; % Total raw oil storage capacity (tons)
int: StorageCost; % Storage cost per ton per month

float: MaxHardness; % Maximum allowed hardness of final product
float: MinHardness; % Minimum required hardness of final product
array[OILS] of float: Hardness; % Hardness of each oil

int: InitialAmount; % Initial amount in storage for each oil (tons)

% Variables
array[MONTHS, OILS] of var 0..StorageSize: buy;     % Tons of raw oil i bought in month m
array[MONTHS, OILS] of var 0..StorageSize: refine;  % Tons of oil i refined/used in month m
array[0..M, OILS]   of var 0..StorageSize: stock;   % Tons of raw oil i in storage at end of month m

array[MONTHS] of var 0..(MaxVegetableRefiningPerMonth + MaxNonVegetableRefiningPerMonth): total_refined;
var int: profit;

% Constraints

% Initial and terminal stock requirements
constraint forall(i in OILS) ( stock[0, i] = InitialAmount );
constraint forall(i in OILS) ( stock[M, i] = stock[0, i] );

% Inventory balance
constraint forall(m in MONTHS, i in OILS) (
  stock[m, i] = stock[m-1, i] + buy[m, i] - refine[m, i]
);

% Storage capacity
constraint forall(m in 0..M) (
  sum(i in OILS)(stock[m, i]) <= StorageSize
);

% Refining capacity by line type (veg / non-veg)
constraint forall(m in MONTHS) (
  sum(i in OILS where IsVegetable[i])(refine[m, i]) <= MaxVegetableRefiningPerMonth
);
constraint forall(m in MONTHS) (
  sum(i in OILS where not IsVegetable[i])(refine[m, i]) <= MaxNonVegetableRefiningPerMonth
);

% Total refined definition
constraint forall(m in MONTHS) (
  total_refined[m] = sum(i in OILS)(refine[m, i])
);

% Hardness constraints (only meaningful if something is produced)
constraint forall(m in MONTHS) (
  total_refined[m] = 0 \/
  sum(i in OILS)(Hardness[i] * (refine[m, i] * 1.0)) >= MinHardness * (total_refined[m] * 1.0)
);
constraint forall(m in MONTHS) (
  total_refined[m] = 0 \/
  sum(i in OILS)(Hardness[i] * (refine[m, i] * 1.0)) <= MaxHardness * (total_refined[m] * 1.0)
);

% Objective
constraint
  profit =
    sum(m in MONTHS)(
      SellPrice * total_refined[m]
      - sum(i in OILS)(BuyPrice[m, i] * buy[m, i])
      - StorageCost * sum(i in OILS)(stock[m, i])
    );

solve maximize profit;