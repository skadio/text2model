% Parameters
int: I;
int: M;

set of int: OILS   = 1..I;
set of int: MONTHS = 1..M;

/* -------------------- data -------------------- */
array[MONTHS, OILS] of float: BuyPrice;          % buying price of oil i in month m
float: SellPrice;                                % selling price of the final product

array[OILS] of bool: IsVegetable;                % vegetable indicator

float: MaxVegRefiningPerMonth;                   % veg-oil refining capacity
float: MaxNonVegRefiningPerMonth;                % non-veg oil refining capacity

float: StorageSize;                              % total storage capacity (all oils together)
float: StorageCost;                              % cost per ton stored per month

float: MaxHardness;                              % technological hardness limits
float: MinHardness;

array[OILS] of float: Hardness;                  % hardness of each oil

float: InitialAmount;                            % initial (and final) inventory of every oil
float: MinUsage;                                 % minimum usage if an oil is used

array[OILS, OILS] of int: Dependencies;          % usage dependencies (0/1)


/* ------------------ derived ------------------- */
float: HardnessMax = max(i in OILS)(Hardness[i]);
float: BigM        = StorageSize + MaxVegRefiningPerMonth + MaxNonVegRefiningPerMonth;

set of int: VegOils    = { i | i in OILS where IsVegetable[i] };
set of int: NonVegOils = { i | i in OILS where not IsVegetable[i] };


/* ------------------ variables ----------------- */
array[MONTHS, OILS] of var 0.0..BigM:        Buy;     % tons bought
array[MONTHS, OILS] of var 0.0..BigM:        Use;     % tons refined / used
array[MONTHS, OILS] of var 0.0..StorageSize: Store;   % inventory at end of month
array[MONTHS, OILS] of var bool:             Used;    % true if oil i is used in month m

array[MONTHS] of var 0.0..BigM*I:            TotalUse;         % total refined each month
array[MONTHS] of var float:                  WeightedHardness; % Σ hardness*use each month


/* ----------------- constraints ---------------- */

/* 1. Link usage decision with quantity */
constraint
  forall(m in MONTHS, i in OILS)(
        Use[m,i] >=        MinUsage * bool2int(Used[m,i])
    /\  Use[m,i] <=           BigM   * bool2int(Used[m,i])
  );

/* 2. At most three oils can be used per month */
constraint
  forall(m in MONTHS)(
        sum(i in OILS)(bool2int(Used[m,i])) <= 3
  );

/* 3. Usage dependencies (if i is used, j must also be used) */
constraint
  forall(m in MONTHS, i in OILS, j in OILS where Dependencies[i,j] = 1)(
        bool2int(Used[m,i]) <= bool2int(Used[m,j])
  );

/* 4. Material balance for every oil */
constraint
  forall(i in OILS)(
        float(InitialAmount) + Buy[1,i] = Use[1,i] + Store[1,i]
  ) /\
  forall(m in 2..M, i in OILS)(
        Store[m-1,i] + Buy[m,i] = Use[m,i] + Store[m,i]
  );

/* 5. End-of-horizon inventory requirement */
constraint
  forall(i in OILS)(
        Store[M,i] = InitialAmount
  );

/* 6. Global storage capacity */
constraint
  forall(m in MONTHS)(
        sum(i in OILS)(Store[m,i]) <= StorageSize
  );

/* 7. Refining capacities */
constraint
  forall(m in MONTHS)(
        sum(i in VegOils   )(Use[m,i]) <= MaxVegRefiningPerMonth /\
        sum(i in NonVegOils)(Use[m,i]) <= MaxNonVegRefiningPerMonth
  );

/* 8. Totals for each month */
constraint
  forall(m in MONTHS)(
        TotalUse[m]         = sum(i in OILS)(Use[m,i]) /\
        WeightedHardness[m] = sum(i in OILS)(Hardness[i] * Use[m,i])
  );

/* 9. Hardness specification (skipped when nothing is produced) */
constraint
  forall(m in MONTHS)(
        (TotalUse[m] = 0.0) \/
        ( float(MinHardness) * TotalUse[m] <= WeightedHardness[m] /\
          WeightedHardness[m] <= float(MaxHardness) * TotalUse[m] )
  );


/* ------------------ objective ----------------- */
var float: Profit =
        SellPrice * sum(m in MONTHS)(TotalUse[m])
      - sum(m in MONTHS, i in OILS)(BuyPrice[m,i] * Buy[m,i])
      - StorageCost * sum(m in MONTHS, i in OILS)(Store[m,i]);

solve maximize Profit;