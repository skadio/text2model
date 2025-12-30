include "globals.mzn";

/* -------------------- PARAMETERS (from the .dzn file) -------------------- */
int: I;                                 % number of oil types
int: M;                                 % number of months

array[1..I,1..M] of int: BuyPrice;      % buying price of oil i in month m
int: SellPrice;                         % selling price of the final product

array[1..I] of bool: IsVegetable;       % true if oil i is a vegetable oil

int: MaxVegRefiningPerMonth;            % capacity for vegetable oil
int: MaxNonVegRefiningPerMonth;         % capacity for non‑vegetable oil

int: StorageSize;                       % storage capacity for raw oil
int: StorageCost;                       % cost per unit per month

float: MaxHardness;                     % maximum hardness of final product
float: MinHardness;                     % minimum hardness of final product

array[1..I] of float: Hardness;         % hardness of each oil type

int: InitialAmount;                     % initial amount of each oil type
int: MinUsage;                          % minimum usage when an oil is used

array[1..I,1..I] of int: Dependencies; % 1 if oil i requires oil j

/* -------------------- VARIABLES ----------------------------------------- */
int: MaxBuy = StorageSize + InitialAmount;  % an upper bound for buying

array[1..M,1..I] of var 0..MaxBuy: buy;     % amount of oil i bought in month m
array[1..M,1..I] of var 0..MaxBuy: refine;  % amount of oil i refined in month m
array[1..M,1..I] of var 0..StorageSize: storage;  % ending storage after month m

array[1..M,1..I] of var bool: use;          % true if oil i is used in month m
array[1..M] of var 0..I: oilCount;          % number of oils used in month m

array[1..M] of var int: produce;            % total amount of product in month m
array[1..M] of var float: hardWeighted;     % weighted hardness of product in month m

/* -------------------- CONSTRAINTS -------------------------------------- */

/* Link use with refined amount */
constraint forall(m in 1..M, i in 1..I)
    (use[m,i] <-> refine[m,i] > 0);

/* Minimum usage when an oil is used */
constraint forall(m in 1..M, i in 1..I)
    refine[m,i] >= MinUsage * (bool2int(use[m,i]));

/* Dependency constraints */
constraint forall(m in 1..M, i in 1..I, j in 1..I)
    (Dependencies[i,j] == 1 -> (use[m,i] -> use[m,j]));

/* Count of oils used per month (at most 3) */
constraint forall(m in 1..M)
    count(use[m,1..I], true, oilCount[m]) <= 3;

/* Refining capacity constraints */
constraint forall(m in 1..M)
    sum(i in 1..I) (bool2int(IsVegetable[i]) * refine[m,i]) <= MaxVegRefiningPerMonth;

constraint forall(m in 1..M)
    sum(i in 1..I) ((1 - bool2int(IsVegetable[i])) * refine[m,i]) <= MaxNonVegRefiningPerMonth;

/* Storage dynamics */
constraint forall(m in 1..M, i in 1..I)
    (m == 1 ->
        storage[m,i] == InitialAmount + buy[m,i] - refine[m,i]
     :
        storage[m,i] == storage[m-1,i] + buy[m,i] - refine[m,i]);

/* Storage must stay within limits */
constraint forall(m in 1..M, i in 1..I)
    storage[m,i] >= 0 /\ storage[m,i] <= StorageSize;

/* Final storage equals initial storage */
constraint forall(i in 1..I)
    storage[M,i] == InitialAmount;

/* Define product and weighted hardness */
constraint forall(m in 1..M)
    produce[m] == sum(i in 1..I) refine[m,i];

constraint forall(m in 1..M)
    hardWeighted[m] == sum(i in 1..I) refine[m,i] * Hardness[i];

/* Hardness bounds (only relevant if some product is made) */
constraint forall(m in 1..M)
    (produce[m] > 0 ->
        (hardWeighted[m] >= MinHardness * produce[m] /\ 
         hardWeighted[m] <= MaxHardness * produce[m]));

/* -------------------- OBJECTIVE ---------------------------------------- */
int: totalRevenue = sum(m in 1..M) SellPrice * produce[m];
int: totalBuyCost   = sum(m in 1..M, i in 1..I) BuyPrice[i,m] * buy[m,i];
int: totalStorageCost = sum(m in 1..M, i in 1..I) StorageCost * storage[m,i];

var int: profit;
constraint profit == totalRevenue - totalBuyCost - totalStorageCost;

solve maximize profit;

/* -------------------- OUTPUT -------------------------------------------- */
output [
  "Profit = ", show(profit), "\n",
  "\nMonth\tProduct\tHardness\n",
  forall(m in 1..M) (
    show(m) ++ "\t" ++ show(produce[m]) ++ "\t" ++
    (produce[m] > 0 then show(round(hardWeighted[m]*100)/100.0) else "N/A") ++ "\n"
  ),
  "\nUse Matrix (rows = months, columns = oils)\n",
  concat([show(use[m,1..I]) ++ "\n" | m in 1..M])
];