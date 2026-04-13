% Parameters
int: M; % number of machine types
int: K; % number of product types
int: I; % number of time periods (months)

set of int: MACHINES = 1..M;
set of int: PRODUCTS = 1..K;
set of int: PERIODS  = 1..I;

array[MACHINES] of int: NumMachines;            % number of machines of each type m
array[PRODUCTS] of int: Profit;                 % profit per unit of product k
array[PRODUCTS, MACHINES] of float: Time;       % processing time of product k on machine m (hours/unit)

array[PERIODS, MACHINES] of int: Maintain;      % machines of type m down for maintenance in period i
array[PRODUCTS, PERIODS] of int: Limit;         % max amount of product k that may be produced in period i

float: StorePrice;                              % storage cost per unit per period
int: KeepQuantity;                              % minimum end-of-period stock requirement (same for all products)
float: WorkHours;                               % working hours per day

% Fixed assumptions from the problem statement
int: DaysPerPeriod = 24;                        % days in a month
int: StorageCap = 100;                          % max stock per product type

% Useful bounds
int: MaxLimit = max([Limit[k,i] | k in PRODUCTS, i in PERIODS]);

% Variables
array[PRODUCTS, PERIODS] of var 0..MaxLimit: Make; % units of product k manufactured in period i
array[PRODUCTS, PERIODS] of var 0..MaxLimit: Sell; % units of product k sold in period i
array[PRODUCTS, PERIODS] of var 0..StorageCap: Stock; % end-of-period inventory

% Constraints

% --- Machine capacity constraints (per machine type and period) ---
constraint
  forall(m in MACHINES, i in PERIODS) (
    sum(k in PRODUCTS)( Time[k,m] * int2float(Make[k,i]) )
    <=
    int2float(NumMachines[m] - Maintain[i,m]) * WorkHours * int2float(DaysPerPeriod)
  );

% --- Production upper bounds (given per product and period) ---
constraint
  forall(k in PRODUCTS, i in PERIODS) (
    Make[k,i] <= Limit[k,i]
  );

% --- Inventory balance / flow conservation ---
% Initial stock is zero.
constraint
  forall(k in PRODUCTS) (
    Stock[k,1] = Make[k,1] - Sell[k,1]
  );

constraint
  forall(k in PRODUCTS, i in 2..I) (
    Stock[k,i] = Stock[k,i-1] + Make[k,i] - Sell[k,i]
  );

% --- Sales feasibility ---
constraint
  forall(k in PRODUCTS) (
    Sell[k,1] <= Make[k,1]
  );

constraint
  forall(k in PRODUCTS, i in 2..I) (
    Sell[k,i] <= Stock[k,i-1] + Make[k,i]
  );

% --- Storage capacity ---
constraint
  forall(k in PRODUCTS, i in PERIODS) (
    Stock[k,i] <= StorageCap
  );

% --- Minimum end-of-period stock requirements (periods 2..I) ---
constraint
  forall(k in PRODUCTS, i in 2..I) (
    Stock[k,i] >= KeepQuantity
  );

% Objective
solve maximize
  sum(k in PRODUCTS, i in PERIODS)( Profit[k] * Sell[k,i] )
  - StorePrice * sum(k in PRODUCTS, i in PERIODS)( int2float(Stock[k,i]) );