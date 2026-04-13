int: M;
int: K;
int: I;

array[1..M] of int: NumMachines;
array[1..K] of float: Profit;
array[1..K, 1..M] of float: Time;
array[1..M] of int: Downtime;
array[1..K, 1..I] of int: Limit;
float: StorePrice;
int: KeepQuantity;
float: WorkHours;

int: DaysPerMonth = 24;
int: ShiftsPerDay = 2;
float: HoursPerMonth = WorkHours * int2float(DaysPerMonth * ShiftsPerDay);

int: MaxProd = max([Limit[k,i] | k in 1..K, i in 1..I]);
int: MaxStock = 100;

array[1..K, 1..I] of var 0..MaxProd: make;
array[1..K, 1..I] of var 0..MaxProd: sell;
array[1..K, 1..I] of var 0..MaxStock: stock;

var float: total_profit;

constraint
  forall(k in 1..K, i in 1..I) (
    make[k,i] <= Limit[k,i]
  );

constraint
  forall(k in 1..K) (
    stock[k,1] = make[k,1] - sell[k,1]
  );

constraint
  forall(k in 1..K, i in 2..I) (
    stock[k,i] = stock[k,i-1] + make[k,i] - sell[k,i]
  );

constraint
  forall(k in 1..K) (
    sell[k,1] <= make[k,1]
  );

constraint
  forall(k in 1..K, i in 2..I) (
    sell[k,i] <= stock[k,i-1] + make[k,i]
  );

constraint
  forall(k in 1..K, i in 1..I) (
    stock[k,i] <= MaxStock
  );

constraint
  forall(k in 1..K, i in 2..I) (
    stock[k,i] >= KeepQuantity
  );

constraint
  forall(m in 1..M, i in 1..I) (
    sum(k in 1..K) ( Time[k,m] * int2float(make[k,i]) )
    <=
    (if i <= Downtime[m] then 0.0 else int2float(NumMachines[m]) * HoursPerMonth endif)
  );

constraint
  total_profit =
    sum(k in 1..K, i in 1..I) ( Profit[k] * int2float(sell[k,i]) )
    - StorePrice * sum(k in 1..K, i in 1..I) ( int2float(stock[k,i]) );

solve maximize total_profit;