% Parameters
int: I; % number of oil types
int: M; % number of months

set of int: OILS = 1..I;    % oil index set
set of int: MONTHS = 1..M;  % month index set

array[OILS, MONTHS] of int: BuyPrice; % buying price of oil i in month m
int: SellPrice; % selling price per ton of final product

array[OILS] of bool: IsVegetable; % true if oil i is vegetable, false otherwise

int: MaxVegRefiningPerMonth;    % max tons of vegetable oils that can be refined per month
int: MaxNonVegRefiningPerMonth; % max tons of non-vegetable oils that can be refined per month

int: StorageSize; % total storage capacity for raw oil (tons)
int: StorageCost; % storage cost per ton per month

float: MaxHardness; % maximum allowed hardness of final blend
float: MinHardness; % minimum allowed hardness of final blend
array[OILS] of float: Hardness; % hardness of each oil type

int: InitialAmount; % initial raw oil inventory (tons) for each oil type (same for all types)
int: MinUsage; % if an oil is used in a month, at least this many tons must be used

array[OILS, OILS] of int: Dependencies;
% Dependencies[i,j] = 1 means: if oil i is used in a month, oil j must also be used


% Variables
array[OILS, MONTHS] of var 0..StorageSize: buy;     % tons of raw oil i bought in month m
array[OILS, MONTHS] of var 0..StorageSize: refine;  % tons of oil i refined/used in month m
array[OILS, 0..M] of var 0..StorageSize: stock;     % tons of raw oil i in storage at end of month t (t=0 is initial)

array[OILS, MONTHS] of var bool: used; % true if oil i is used (refined) in month m

array[MONTHS] of var 0..(MaxVegRefiningPerMonth + MaxNonVegRefiningPerMonth): production;
% total tons of final product produced in month m (equals total refined amount that month)


% Constraints

% --- Inventory balance (raw oil flow) ---
% Initial stock for each oil type
constraint
  forall(i in OILS)(
    stock[i,0] = InitialAmount
  );

% Stock evolution: end-of-month stock = previous stock + bought - refined
constraint
  forall(i in OILS, m in MONTHS)(
    stock[i,m] = stock[i,m-1] + buy[i,m] - refine[i,m]
  );

% Cannot refine more than available raw oil (tightening)
constraint
  forall(i in OILS, m in MONTHS)(
    refine[i,m] <= stock[i,m-1] + buy[i,m]
  );

% End condition: finish with the same stock as initially for each oil
constraint
  forall(i in OILS)(
    stock[i,M] = InitialAmount
  );

% --- Storage capacity (only raw oil can be stored) ---
constraint
  forall(m in 0..M)(
    sum(i in OILS)(stock[i,m]) <= StorageSize
  );

% --- Refining capacity constraints (veg/non-veg lines) ---
constraint
  forall(m in MONTHS)(
    sum(i in OILS where IsVegetable[i])(refine[i,m]) <= MaxVegRefiningPerMonth
  );

constraint
  forall(m in MONTHS)(
    sum(i in OILS where not IsVegetable[i])(refine[i,m]) <= MaxNonVegRefiningPerMonth
  );

% --- Production definition (no loss in refining; production equals total refined) ---
constraint
  forall(m in MONTHS)(
    production[m] = sum(i in OILS)(refine[i,m])
  );

% --- Usage indicators, min-usage, and max number of oils per month ---
% If used then refine is at least MinUsage; if not used then refine must be 0.
constraint
  forall(i in OILS, m in MONTHS)(
    refine[i,m] <= StorageSize * bool2int(used[i,m])
  );

constraint
  forall(i in OILS, m in MONTHS)(
    refine[i,m] >= MinUsage * bool2int(used[i,m])
  );

% At most three oils used in any month
constraint
  forall(m in MONTHS)(
    sum(i in OILS)(bool2int(used[i,m])) <= 3
  );

% --- Dependency constraints between oils (if i used then j used) ---
constraint
  forall(m in MONTHS, i in OILS, j in OILS where Dependencies[i,j] = 1)(
    bool2int(used[i,m]) <= bool2int(used[j,m])
  );

% --- Hardness (weighted average of blend must be within bounds) ---
% Enforce: MinHardness <= (sum refine*Hardness)/production <= MaxHardness
% Linearized without division; only applies when production > 0.
constraint
  forall(m in MONTHS)(
    production[m] = 0 \/
    (
      sum(i in OILS)(Hardness[i] * int2float(refine[i,m]))
        >= MinHardness * int2float(production[m])
      /\
      sum(i in OILS)(Hardness[i] * int2float(refine[i,m]))
        <= MaxHardness * int2float(production[m])
    )
  );


% Objective
solve maximize
  sum(m in MONTHS)(
      SellPrice * production[m]
    - sum(i in OILS)(BuyPrice[i,m] * buy[i,m])
    - StorageCost * sum(i in OILS)(stock[i,m])
  );