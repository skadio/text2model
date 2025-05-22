int: M;
int: K;
int: I;

array[1..M] of int: NumMachines;
array[1..K] of int: Profit;
array[1..K, 1..M] of float: Time;
array[1..I, 1..M] of int: Maintain;
array[1..K, 1..I] of int: Limit;
float: StorePrice;
array[1..K] of int: KeepQuantity;
float: WorkHours;

int: Days = 24;

int: MaxLimit = max([Limit[k,i] | k in 1..K, i in 1..I]);
int: MaxStore = 100;

array[1..K, 1..I] of var 0..MaxLimit: Prod;
array[1..K, 1..I] of var 0..MaxLimit: Sales;
array[1..K, 1..I] of var 0..MaxStore: Stock;

constraint
  forall(i in 1..I, m in 1..M)(
    sum(k in 1..K)( Time[k,m] * int2float(Prod[k,i]) )
    <= int2float(NumMachines[m] - Maintain[i,m]) * WorkHours * int2float(Days)
  );

constraint
  forall(k in 1..K, i in 1..I)(
    Prod[k,i] <= Limit[k,i]
  );

constraint
  forall(k in 1..K)(
    Stock[k,1] = Prod[k,1] - Sales[k,1]
  );

constraint
  forall(k in 1..K, i in 2..I)(
    Stock[k,i] = Stock[k,i-1] + Prod[k,i] - Sales[k,i]
  );

constraint
  forall(k in 1..K)(
    Stock[k,I] >= KeepQuantity[k]
  );

var float: ProfitObj =
    sum(k in 1..K, i in 1..I)( int2float(Profit[k]) * int2float(Sales[k,i]) )
  - sum(k in 1..K, i in 1..I)( StorePrice * int2float(Stock[k,i]) );

solve maximize ProfitObj;