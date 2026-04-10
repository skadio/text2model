% Parameters
int: M;                              % number of machine types
int: K;                              % number of product types
int: I;                              % number of time periods (months)

set of int: MACHINES = 1..M;
set of int: PRODUCTS = 1..K;
set of int: PERIODS  = 1..I;

array[MACHINES] of int: NumMachines;                 % number of machines of each type
array[PRODUCTS] of int: Profit;                      % profit per unit sold for each product
array[PRODUCTS, MACHINES] of float: Time;            % hours required on machine m per unit of product k

% Downtime given in data may be array2d(1..1,1..M,[...]) so accept 2D then map to 1D.
array[1..1, MACHINES] of int: DowntimeData;
array[MACHINES] of int: Downtime = [DowntimeData[1,m] | m in MACHINES];

array[PRODUCTS, PERIODS] of int: Limit;              % per-product per-period upper bound

float: StorePrice;                   % storage cost per unit per month
int: KeepQuantity;                   % required minimum ending stock in each period (after the first)
float: WorkHours;                    % hours per shift

% Fixed constants from the problem statement
int: DaysPerMonth = 24;
int: ShiftsPerDay = 2;
int: MaxStorage   = 100;

% Variables
array[PRODUCTS, PERIODS] of var 0..MaxStorage: StockEnd;   % end-of-period inventory
array[PRODUCTS, PERIODS] of var 0..max(Limit): Produce;    % units produced
array[PRODUCTS, PERIODS] of var 0..max(Limit): Sell;       % units sold

var float: TotalProfit;

% Constraints

% Per-period limits
constraint
  forall(k in PRODUCTS, i in PERIODS) (
    Produce[k,i] <= Limit[k,i] /\
    Sell[k,i]    <= Limit[k,i]
  );

% Inventory balance (start with zero stock)
constraint forall(k in PRODUCTS) (
  StockEnd[k,1] = Produce[k,1] - Sell[k,1]
);

constraint forall(k in PRODUCTS, i in 2..I) (
  StockEnd[k,i] = StockEnd[k,i-1] + Produce[k,i] - Sell[k,i]
);

% Sales cannot exceed available amount
constraint forall(k in PRODUCTS, i in PERIODS) (
  Sell[k,i] <= Produce[k,i] + (if i = 1 then 0 else StockEnd[k,i-1] endif)
);

% Minimum ending stock after the first period
constraint forall(k in PRODUCTS, i in 2..I) (
  StockEnd[k,i] >= KeepQuantity
);

% Machine capacity constraints per period (simple downtime assumption as in original model)
constraint forall(m in MACHINES, i in PERIODS) (
  sum(k in PRODUCTS)( Time[k,m] * int2float(Produce[k,i]) )
  <=
  int2float(max(0, NumMachines[m] - (if i <= Downtime[m] then 1 else 0 endif)))
  * int2float(DaysPerMonth * ShiftsPerDay) * WorkHours
);

% Objective: sales profit minus holding cost
constraint
  TotalProfit =
    sum(k in PRODUCTS, i in PERIODS)(
      int2float(Profit[k]) * int2float(Sell[k,i]) - StorePrice * int2float(StockEnd[k,i])
    );

solve maximize TotalProfit;