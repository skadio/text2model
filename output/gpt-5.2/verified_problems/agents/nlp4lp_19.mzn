% Parameters
int: M; % Number of months
int: I; % Number of different oils

set of int: MONTHS = 1..M; % Month index set
set of int: OILS   = 1..I; % Oil index set

array[MONTHS, OILS] of int: BuyPrice; % Buy price of oil i in month m

int: SellPrice; % Sell price per ton of final product

array[OILS] of bool: IsVegetable; % True if oil i is vegetable, else non-vegetable

int: MaxVegetableRefiningPerMonth;    % Total refining capacity for vegetable oils per month
int: MaxNonVegetableRefiningPerMonth; % Total refining capacity for non-vegetable oils per month

int: StorageSize; % Total storage capacity (raw oil only)
int: StorageCost; % Storage cost per ton per month

float: MaxHardness; % Maximum allowed product hardness
float: MinHardness; % Minimum required product hardness
array[OILS] of float: Hardness; % Hardness of each oil i

int: InitialAmount; % Initial amount in storage at the beginning (applied per oil type)


% Variables
array[MONTHS, OILS] of var 0..StorageSize: buy;    % Tons of raw oil i bought in month m
array[MONTHS, OILS] of var 0..StorageSize: refine; % Tons of oil i refined/used in month m
array[0..M, OILS] of var 0..StorageSize: stock;    % Raw oil stock of item i at end of month m (m=0 is initial)

array[MONTHS] of var 0..(MaxVegetableRefiningPerMonth + MaxNonVegetableRefiningPerMonth): production;
% Total tons of final product produced in month m (equals total refined in that month)

var int: profit; % Total profit over the planning horizon


% Constraints

% --- Initial and terminal stock requirements ---
constraint
  forall(i in OILS) (
    stock[0, i] = InitialAmount
  );

constraint
  forall(i in OILS) (
    stock[M, i] = stock[0, i]  % End with same stock as started (per oil type)
  );

% --- Inventory balance (raw oil only) ---
constraint
  forall(m in MONTHS, i in OILS) (
    stock[m, i] = stock[m-1, i] + buy[m, i] - refine[m, i]
  );

% --- Storage capacity limit (total raw oil across all types) ---
constraint
  forall(m in 0..M) (
    sum(i in OILS)(stock[m, i]) <= StorageSize
  );

% --- Refining capacity constraints by line type (vegetable vs non-vegetable) ---
constraint
  forall(m in MONTHS) (
    sum(i in OILS where IsVegetable[i]) (refine[m, i]) <= MaxVegetableRefiningPerMonth
  );

constraint
  forall(m in MONTHS) (
    sum(i in OILS where not IsVegetable[i]) (refine[m, i]) <= MaxNonVegetableRefiningPerMonth
  );

% --- Production equals total refined (no loss of weight) ---
constraint
  forall(m in MONTHS) (
    production[m] = sum(i in OILS)(refine[m, i])
  );

% --- Product hardness bounds (weighted average hardness of the blend each month) ---
% Enforce: MinHardness <= (sum_i refine*Hardness) / production <= MaxHardness
% Avoid division by using cross-multiplication; apply only if production > 0.
constraint
  forall(m in MONTHS) (
    (production[m] = 0) \/
    (
      sum(i in OILS)(Hardness[i] * int2float(refine[m, i]))
        >= MinHardness * int2float(production[m])
      /\
      sum(i in OILS)(Hardness[i] * int2float(refine[m, i]))
        <= MaxHardness * int2float(production[m])
    )
  );


% Objective
constraint
  profit =
      sum(m in MONTHS)(SellPrice * production[m])
    - sum(m in MONTHS, i in OILS)(BuyPrice[m, i] * buy[m, i])
    - sum(m in MONTHS, i in OILS)(StorageCost * stock[m, i]);

solve maximize profit;