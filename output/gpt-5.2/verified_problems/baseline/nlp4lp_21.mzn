int: M;
int: K;
int: I;

set of int: MACH = 1..M;
set of int: PROD = 1..K;
set of int: T = 1..I;

array[MACH] of int: NumMachines;
array[PROD] of float: Profit;
array[PROD, MACH] of float: Time;
array[T, MACH] of int: Maintain;
array[PROD, T] of int: Limit;

float: StorePrice;
array[PROD] of int: KeepQuantity;
float: WorkHours;

% Assumptions from statement
float: DaysPerMonth = 24.0;
float: WorkDaysPerWeek = 6.0;

% Effective working hours per machine per month
float: HoursPerMachineMonth = WorkHours * DaysPerMonth;

% Decision variables
array[PROD, T] of var int: Make;     % units produced
array[PROD, T] of var int: Sell;     % units sold
array[PROD, 0..I] of var int: Stock; % end-of-period stock (Stock[k,0]=0)

% Bounds
constraint forall(k in PROD, t in T) (Make[k,t] >= 0 /\ Sell[k,t] >= 0);
constraint forall(k in PROD, t in 0..I) (Stock[k,t] >= 0);

% Initial stock
constraint forall(k in PROD) (Stock[k,0] = 0);

% Production limits (given as Limit[k,t])
constraint forall(k in PROD, t in T) (Make[k,t] <= Limit[k,t]);

% Inventory balance
constraint forall(k in PROD, t in T) (
  Stock[k,t] = Stock[k,t-1] + Make[k,t] - Sell[k,t]
);

% Cannot sell more than available
constraint forall(k in PROD, t in T) (
  Sell[k,t] <= Stock[k,t-1] + Make[k,t]
);

% Storage capacity limit: at most 100 of each product
constraint forall(k in PROD, t in T) (Stock[k,t] <= 100);

% Minimum ending stock requirement at end of each month
constraint forall(k in PROD, t in T) (Stock[k,t] >= KeepQuantity[k]);

% Machine capacity constraints per month
% Available machine-hours in month t for machine m:
% (NumMachines[m] - Maintain[t,m]) * HoursPerMachineMonth
constraint forall(t in T, m in MACH) (
  sum(k in PROD)( Time[k,m] * int2float(Make[k,t]) )
  <= max(0.0, int2float(NumMachines[m] - Maintain[t,m])) * HoursPerMachineMonth
);

% Objective: maximize profit from sales minus storage cost (per unit per month in stock)
var float: TotalRevenue = sum(k in PROD, t in T)( Profit[k] * int2float(Sell[k,t]) );
var float: TotalStorageCost = sum(k in PROD, t in T)( StorePrice * int2float(Stock[k,t]) );

solve maximize TotalRevenue - TotalStorageCost;

output [
  "Objective = ", show(TotalRevenue - TotalStorageCost), "\n",
  "Revenue = ", show(TotalRevenue), "\n",
  "StorageCost = ", show(TotalStorageCost), "\n\n",
  "Make:\n", show(Make), "\n\n",
  "Sell:\n", show(Sell), "\n\n",
  "Stock:\n", show(Stock), "\n"
];