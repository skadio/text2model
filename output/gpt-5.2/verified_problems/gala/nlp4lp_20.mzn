include "globals.mzn";

/********************/
/* Input parameters */
/********************/
int: I;                              % number of oil types
int: M;                              % number of months

array[1..I, 1..M] of int: BuyPrice;  % price to buy oil i in month m
int: SellPrice;                      % selling price per ton of final product

array[1..I] of bool: IsVegetable;    % true if vegetable oil

int: MaxVegRefiningPerMonth;
int: MaxNonVegRefiningPerMonth;

int: StorageSize;                    % max total raw oil in storage (tons)
int: StorageCost;                    % per ton per month

float: MaxHardness;                  % NOTE: despite names in statement, we enforce MinHardness <= avg <= MaxHardness
float: MinHardness;

array[1..I] of float: Hardness;

int: InitialAmount;                  % initial storage amount for each oil (tons)
int: MinUsage;                       % if used, at least this many tons must be refined/used that month

array[1..I, 1..I] of int: Dependencies; % 1 => if i used then j used

/********************/
/* Derived constants */
/********************/
int: MaxRefinePerMonth = MaxVegRefiningPerMonth + MaxNonVegRefiningPerMonth;
int: MaxStorePerOil = StorageSize; % safe per-oil upper bound

/********************/
/* Decision vars     */
/********************/
array[1..M, 1..I] of var 0..StorageSize: buy;     % tons of raw oil i purchased in month m
array[1..M, 1..I] of var 0..StorageSize: refine;  % tons of oil i refined/used in month m
array[0..M, 1..I] of var 0..StorageSize: store;   % raw oil inventory at end of month m (store[0] = initial)

array[1..M, 1..I] of var bool: used;              % whether oil i is used in month m

/********************/
/* Inventory balance */
/********************/
constraint forall(i in 1..I) (
  store[0,i] = InitialAmount
);

constraint forall(m in 1..M, i in 1..I) (
  store[m,i] = store[m-1,i] + buy[m,i] - refine[m,i]
);

/* Storage capacity (total across oils) */
constraint forall(m in 0..M) (
  sum(i in 1..I)(store[m,i]) <= StorageSize
);

/* End inventory equals initial inventory */
constraint forall(i in 1..I) (
  store[M,i] = store[0,i]
);

/********************/
/* Refining capacity */
/********************/
constraint forall(m in 1..M) (
  sum(i in 1..I where IsVegetable[i]) (refine[m,i]) <= MaxVegRefiningPerMonth
);

constraint forall(m in 1..M) (
  sum(i in 1..I where not IsVegetable[i]) (refine[m,i]) <= MaxNonVegRefiningPerMonth
);

/********************/
/* used / min-usage  */
/********************/
constraint forall(m in 1..M, i in 1..I) (
  used[m,i] <-> (refine[m,i] > 0)
);

constraint forall(m in 1..M, i in 1..I) (
  used[m,i] -> refine[m,i] >= MinUsage
);

/* At most 3 oils used each month (hint: count) */
constraint
  forall(m in 1..M) (
    count([ used[m,i] | i in 1..I ], true, 0..3)
  );

/********************/
/* Dependencies      */
/********************/
constraint forall(m in 1..M, i in 1..I, j in 1..I where Dependencies[i,j] = 1) (
  used[m,i] -> used[m,j]
);

/********************/
/* Hardness blending */
/********************/
/* Enforce bounds on weighted average hardness of the month's production.
   If nothing is produced in a month, we do not constrain hardness that month. */
constraint forall(m in 1..M) (
  let {
    var int: prod = sum(i in 1..I)(refine[m,i])
  } in
    prod = 0 \/
    (
      sum(i in 1..I)(Hardness[i] * int2float(refine[m,i])) >= MinHardness * int2float(prod) /\
      sum(i in 1..I)(Hardness[i] * int2float(refine[m,i])) <= MaxHardness * int2float(prod)
    )
);

/********************/
/* Objective: profit */
/********************/
var int: revenue = SellPrice * sum(m in 1..M, i in 1..I)(refine[m,i]);

var int: purchase_cost = sum(m in 1..M, i in 1..I)(BuyPrice[i,m] * buy[m,i]);

/* Storage cost paid for inventory held at end of each month (months 1..M) */
var int: storage_cost = StorageCost * sum(m in 1..M, i in 1..I)(store[m,i]);

var int: profit = revenue - purchase_cost - storage_cost;

solve maximize profit;

/********************/
/* Output            */
/********************/
output [
  "Profit = ", show(profit), "\n",
  "Revenue = ", show(revenue), "  PurchaseCost = ", show(purchase_cost), "  StorageCost = ", show(storage_cost), "\n\n",
  "Buy (month x oil) =\n", show(buy), "\n\n",
  "Refine (month x oil) =\n", show(refine), "\n\n",
  "Store end-of-month (0..M x oil) =\n", show(store), "\n\n",
  "Used (month x oil) =\n", show(used), "\n"
];