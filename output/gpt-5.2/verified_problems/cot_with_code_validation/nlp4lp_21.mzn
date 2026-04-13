% Parameters
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

% Derived constants
int: DaysPerMonth = 24;
float: HoursPerMonthPerMachine = WorkHours * float(DaysPerMonth);

% Helper bounds
int: MaxLimit = max([Limit[k,i] | k in 1..K, i in 1..I]);

% Variables
array[1..K, 1..I] of var 0..MaxLimit: Make;
array[1..K, 1..I] of var 0..MaxLimit: Sell;
array[1..K, 0..I] of var 0..100: Stock;

var float: TotalProfit;

% Constraints
constraint forall(k in 1..K) (
  Stock[k,0] = 0
);

constraint forall(k in 1..K, i in 1..I) (
  Make[k,i] <= Limit[k,i]
);

constraint forall(k in 1..K, i in 1..I) (
  Stock[k,i] = Stock[k,i-1] + Make[k,i] - Sell[k,i]
);

constraint forall(k in 1..K, i in 1..I) (
  Sell[k,i] <= Stock[k,i-1] + Make[k,i]
);

% Minimum end-of-month stock requirement
constraint forall(k in 1..K, i in 1..I) (
  Stock[k,i] >= KeepQuantity[k]
);

% Storage capacity limit
constraint forall(k in 1..K, i in 1..I) (
  Stock[k,i] <= 100
);

% Machine capacity constraints (time available after maintenance)
constraint forall(i in 1..I, m in 1..M) (
  sum(k in 1..K)( Time[k,m] * int2float(Make[k,i]) )
  <= HoursPerMonthPerMachine * int2float(NumMachines[m] - Maintain[i,m])
);

% Objective
constraint TotalProfit =
  sum(k in 1..K, i in 1..I)( int2float(Profit[k]) * int2float(Sell[k,i]) )
  - StorePrice * sum(k in 1..K, i in 1..I)( int2float(Stock[k,i]) );

solve maximize TotalProfit;