include "globals.mzn";

int: I;  % Number of types of oil
int: M;  % Number of months
array[1..I, 1..M] of int: BuyPrice;  % Buying price of oil i in month m
int: SellPrice;  % Selling price of final product
array[1..I] of bool: IsVegetable;  % Indicator whether good i is a vegetable oil or not
int: MaxVegRefiningPerMonth;  % Maximum refining capacity for vegetable oil per month
int: MaxNonVegRefiningPerMonth;  % Maximum refining capacity for non-vegetable oil per month
int: StorageSize;  % Storage capacity for raw oil
int: StorageCost;  % Storage cost per unit per month
int: MaxHardness;  % Maximum hardness of final product
int: MinHardness;  % Minimum hardness of final product
array[1..I] of float: Hardness;  % Hardness of good i
int: InitialAmount;  % Initial amount of oil of each type
int: MinUsage;  % Minimum usage tons if an oil is used
array[1..I, 1..I] of int: Dependencies;  % Dependencies of goods

/* Variables */
array[1..M] of var 0..3: oils_used;  % Number of different oils used each month
array[1..I, 1..M] of var 0..StorageSize: storage;  % Amount of each oil stored at the end of each month
array[1..I, 1..M] of var 0..MaxVegRefiningPerMonth: veg_refined;  % Amount of vegetable oil refined each month
array[1..I, 1..M] of var 0..MaxNonVegRefiningPerMonth: non_veg_refined;  % Amount of non-vegetable oil refined each month

/* Constraints */
constraint count(oils_used, 1, 3);  % At most 3 oils can be used in any month

% Ensure that the total amount of oil stored at the end of the last month is the same as the initial amount
constraint forall(i in 1..I)(
    storage[i, M] = InitialAmount
);

/* Linking constraints for refining and storage */
constraint forall(m in 1..M)(
    let {
        var 0..3: used = oils_used[m]
    } in
    (used > 0 -> 
        (sum(i in 1..I where IsVegetable[i]) (veg_refined[i, m]) >= MinUsage) /\
        (sum(i in 1..I where not IsVegetable[i]) (non_veg_refined[i, m]) >= MinUsage)
    )
);

/* Dependencies handling */
constraint forall(i in 1..I)(
    forall(j in 1..I)(
        Dependencies[i, j] = 1 -> (oils_used[i] > 0 -> oils_used[j] > 0)
    )
);

/* Solve & output */
solve maximize (SellPrice * sum(m in 1..M)(sum(i in 1..I)(veg_refined[i, m] + non_veg_refined[i, m])) - StorageCost * sum(m in 1..M)(sum(i in 1..I)(storage[i, m])));

output [ "Oils used per month: ", show(oils_used), "\n" ];