int: M;
int: K;
int: I;

set of int: Machines = 1..M;
set of int: Products = 1..K;
set of int: Periods  = 1..I;

array[Machines] of int: NumMachines;
array[Products] of int: Profit;
array[Products, Machines] of float: Time;
array[Periods, Machines] of int: Maintain;
array[Products, Periods] of int: Limit;

float: StorePrice;
array[Products] of int: KeepQuantity;
float: WorkHours;

int: DaysPerMonth = 24;
float: HoursPerMonth = WorkHours * int2float(DaysPerMonth) * 6.0;

array[Products, Periods] of var 0..max(Limit): Make;
array[Products, Periods] of var 0..max(Limit): Sell;
array[Products, 0..I] of var 0..100: Stock;

var float: TotalProfit;

constraint forall(k in Products) (
  Stock[k,0] = 0
);

constraint forall(k in Products, i in Periods) (
  Stock[k,i] = Stock[k,i-1] + Make[k,i] - Sell[k,i]
);

constraint forall(k in Products, i in Periods) (
  Sell[k,i] <= Stock[k,i-1] + Make[k,i]
);

constraint forall(k in Products, i in Periods) (
  Make[k,i] <= Limit[k,i]
);

constraint forall(k in Products, i in 2..I) (
  Stock[k,i] >= KeepQuantity[k]
);

constraint forall(m in Machines, i in Periods) (
  sum(k in Products)( Time[k,m] * int2float(Make[k,i]) )
  <= int2float(max(0, NumMachines[m] - Maintain[i,m])) * HoursPerMonth
);

constraint
  TotalProfit =
    sum(k in Products, i in Periods)( int2float(Profit[k]) * int2float(Sell[k,i]) )
    - StorePrice * sum(k in Products, i in Periods)( int2float(Stock[k,i]) );

solve maximize TotalProfit;