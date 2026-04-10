int: M;
int: K;
int: I;

set of int: MACH = 1..M;
set of int: PROD = 1..K;
set of int: PER  = 1..I;

array[MACH] of int: NumMachines;
array[PROD] of int: Profit;
array[PROD, MACH] of float: Time;
array[PER, MACH] of int: Maintain;
array[PROD, PER] of int: Limit;

float: StorePrice;
array[PROD] of int: KeepQuantity;
float: WorkHours;

float: DaysPerPeriod = 24.0;
float: WorkTimePerMachinePerPeriod = DaysPerPeriod * 6.0 * WorkHours;

int: MaxLimit = max([Limit[k,i] | k in PROD, i in PER]);
int: MaxStore = 100;

array[PROD, PER] of var 0..MaxLimit: Make;
array[PROD, PER] of var 0..MaxLimit: Sell;
array[PROD, 0..I] of var 0..MaxStore: Stock;

var int: TotalProfit;

constraint forall(k in PROD) (Stock[k,0] = 0);

constraint forall(k in PROD, i in PER) (Make[k,i] <= Limit[k,i]);

constraint forall(k in PROD, i in PER) (
  Stock[k,i] = Stock[k,i-1] + Make[k,i] - Sell[k,i]
);

constraint forall(k in PROD, i in PER) (
  0 <= Sell[k,i] /\ Sell[k,i] <= Stock[k,i-1] + Make[k,i]
);

constraint forall(k in PROD, i in PER) (Stock[k,i] <= MaxStore);

constraint forall(k in PROD, i in PER where i >= 2) (
  Stock[k,i] >= KeepQuantity[k]
);

constraint forall(i in PER, m in MACH) (
  sum(k in PROD)(Time[k,m] * int2float(Make[k,i]))
  <= int2float(NumMachines[m] - Maintain[i,m]) * WorkTimePerMachinePerPeriod
);

constraint
  TotalProfit =
    sum(k in PROD, i in PER)(Profit[k] * Sell[k,i])
    - round(StorePrice * int2float(sum(k in PROD, i in PER)(Stock[k,i])));

solve maximize TotalProfit;