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

float: HoursPerMonth = WorkHours * 2.0 * 24.0;

array[1..K * I] of int: Limit_flat = [ Limit[k, t] | k in 1..K, t in 1..I ];
int: MaxLimit = max(Limit_flat);
int: MaxStock = max([KeepQuantity, 100]);
int: MaxShip  = MaxLimit + MaxStock;

set of int: PRODUCTS = 1..K;
set of int: MACHINES = 1..M;
set of int: PERIODS  = 1..I;

array[PRODUCTS, PERIODS] of var 0..MaxLimit : prod;
array[PRODUCTS, PERIODS] of var 0..MaxShip  : ship;
array[PRODUCTS, PERIODS] of var 0..MaxStock : stock;
array[MACHINES, PERIODS] of var 0..1        : down;

constraint
  forall(k in PRODUCTS, t in PERIODS)(
    prod[k, t] <= Limit[k, t]
  );

constraint
  forall(k in PRODUCTS)(
    stock[k, 1] = prod[k, 1] - ship[k, 1]
  );

constraint
  forall(k in PRODUCTS, t in 2..I)(
    stock[k, t] = stock[k, t - 1] + prod[k, t] - ship[k, t]
  );

constraint
  forall(k in PRODUCTS, t in PERIODS)(
    stock[k, t] >= KeepQuantity
  );

constraint
  forall(m in MACHINES, t in PERIODS)(
    sum(k in PRODUCTS)(
      Time[k, m] * int2float(prod[k, t])
    )
    <= int2float(NumMachines[m]) * (1.0 - int2float(down[m, t])) * HoursPerMonth
  );

constraint
  forall(m in MACHINES)(
    sum(t in PERIODS)(down[m, t]) = Downtime[m]
  );

solve maximize
  sum(k in PRODUCTS, t in PERIODS)(
    Profit[k] * int2float(ship[k, t])
  )
  - StorePrice * sum(k in PRODUCTS, t in PERIODS)(
    int2float(stock[k, t])
  );