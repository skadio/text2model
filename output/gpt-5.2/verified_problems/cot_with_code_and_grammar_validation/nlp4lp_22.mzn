int: M;
int: K;
int: I;

array[1..M] of int: NumMachines;
array[1..K] of int: Profit;
array[1..K, 1..M] of float: Time;
array[1..M] of int: Downtime;
array[1..K, 1..I] of int: Limit;

float: StorePrice;
int: KeepQuantity;
float: WorkHours;

int: DaysPerMonth = 24;
int: ShiftsPerDay = 2;
float: HoursPerShift = WorkHours;

float: HoursPerMachinePerMonth =
  int2float(DaysPerMonth * ShiftsPerDay) * HoursPerShift;

array[1..M, 1..I] of float: Capacity =
  array2d(1..M, 1..I,
    [ int2float(max(0, NumMachines[m] - (if t <= Downtime[m] then 1 else 0 endif)))
      * HoursPerMachinePerMonth
    | m in 1..M, t in 1..I ]
  );

int: MaxLimit = max([Limit[k,t] | k in 1..K, t in 1..I]);

array[1..K, 1..I] of var 0..MaxLimit: Make;
array[1..K, 1..I] of var 0..MaxLimit: Sell;

array[1..K, 0..I] of var 0..100: Stock;

var float: TotalProfit;

constraint forall(k in 1..K) (
  Stock[k,0] = 0
);

constraint forall(k in 1..K, t in 1..I) (
  Make[k,t] <= Limit[k,t]
);

constraint forall(k in 1..K, t in 1..I) (
  Stock[k,t] = Stock[k,t-1] + Make[k,t] - Sell[k,t]
);

constraint forall(k in 1..K, t in 1..I) (
  Stock[k,t] <= 100
);

constraint forall(k in 1..K, t in 2..I) (
  Stock[k,t] >= KeepQuantity
);

constraint forall(m in 1..M, t in 1..I) (
  sum(k in 1..K) ( Time[k,m] * int2float(Make[k,t]) ) <= Capacity[m,t]
);

constraint
  TotalProfit =
    sum(k in 1..K, t in 1..I) ( int2float(Profit[k]) * int2float(Sell[k,t]) )
    - StorePrice * sum(k in 1..K, t in 1..I) ( int2float(Stock[k,t]) );

solve maximize TotalProfit;