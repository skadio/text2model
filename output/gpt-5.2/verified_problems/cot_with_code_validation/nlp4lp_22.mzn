% Optimal selling/storing/manufacturing policy

% --------------------
% Parameters (from .dzn)
% --------------------
int: M;                 % number of machine types
int: K;                 % number of product types
int: I;                 % number of months

array[1..M] of int: NumMachines;
array[1..K] of int: Profit;

array[1..K, 1..M] of float: Time;

% Downtime given per month and machine (as in generated model)
array[1..I, 1..M] of int: Downtime;

array[1..K, 1..I] of int: Limit;

float: StorePrice;
int: KeepQuantity;
float: WorkHours;

% --------------------
% Derived constants
% --------------------
int: DaysPerMonth = 24;
int: ShiftsPerDay = 2;
float: HoursPerMonth = WorkHours * float(DaysPerMonth * ShiftsPerDay);

array[1..I, 1..M] of float: AvailHours =
  array2d(1..I, 1..M,
    [ HoursPerMonth * float(NumMachines[m] - Downtime[i,m])
    | i in 1..I, m in 1..M
    ]);

% Upper bound for production/sales variables
int: MaxLimit = max([Limit[k,i] | k in 1..K, i in 1..I]);

% --------------------
% Decision variables
% --------------------
array[1..K, 1..I] of var 0..MaxLimit: Make;
array[1..K, 1..I] of var 0..MaxLimit: Sell;

% Stock at end of each month (including month 0 = initial stock)
array[1..K, 0..I] of var 0..KeepQuantity: Stock;

% --------------------
% Constraints
% --------------------
constraint forall(k in 1..K) (Stock[k,0] = 0);

constraint
  forall(k in 1..K, i in 1..I) (
    Stock[k,i] = Stock[k,i-1] + Make[k,i] - Sell[k,i]
  );

constraint forall(k in 1..K, i in 1..I) (Make[k,i] <= Limit[k,i]);

constraint
  forall(k in 1..K, i in 1..I) (
    Sell[k,i] <= Stock[k,i-1] + Make[k,i]
  );

constraint forall(k in 1..K, i in 1..I) (Stock[k,i] <= KeepQuantity);

% Minimum stock required at the end of the final month
constraint forall(k in 1..K) (Stock[k,I] >= KeepQuantity);

% Machine capacity by month
constraint
  forall(i in 1..I, m in 1..M) (
    sum(k in 1..K)( Time[k,m] * int2float(Make[k,i]) ) <= AvailHours[i,m]
  );

% --------------------
% Objective
% --------------------
var float: TotalProfit =
    sum(k in 1..K, i in 1..I)( int2float(Profit[k]) * int2float(Sell[k,i]) )
  - sum(k in 1..K, i in 1..I)( StorePrice * int2float(Stock[k,i]) );

solve maximize TotalProfit;