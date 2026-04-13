% Parameters
int: M; % number of machine types
int: K; % number of product types
int: I; % number of time periods (months)

set of int: MACHINES = 1..M;
set of int: PRODUCTS = 1..K;
set of int: PERIODS  = 1..I;

array[MACHINES] of int: NumMachines;          % number of machines of each type m
array[PRODUCTS] of int: Profit;               % profit per unit of product k

array[PRODUCTS, MACHINES] of float: Time;     % processing time for product k on machine m (hours per unit)
array[PERIODS, MACHINES] of int: Maintain;    % number of machines of type m down in period i
array[PRODUCTS, PERIODS] of int: Limit;       % production/sales limit for product k in period i

float: StorePrice;                            % storage cost per unit per month
array[PRODUCTS] of int: KeepQuantity;         % minimum ending inventory required for each product k
float: WorkHours;                             % working hours per day
float: DaysPerMonth = 24.0;                   % fixed at 24 days/month as per statement

% Variables
array[PRODUCTS, PERIODS] of var 0..1000: Make;  % units of product k manufactured in period i
array[PRODUCTS, PERIODS] of var 0..1000: Sell;  % units of product k sold in period i
array[PRODUCTS, PERIODS] of var 0..100:  Stock; % end-of-period inventory of product k in period i

var float: TotalProfit; % objective value (profit minus storage costs)

% Constraints

% --- Inventory balance constraints (flow conservation) ---
% End-of-period stock equals previous stock plus production minus sales.
constraint
  forall(k in PRODUCTS) (
    Stock[k,1] = Make[k,1] - Sell[k,1]  % initial stock is 0
  );

constraint
  forall(k in PRODUCTS, i in 2..I) (
    Stock[k,i] = Stock[k,i-1] + Make[k,i] - Sell[k,i]
  );

% --- Feasibility of sales w.r.t. available inventory ---
% Cannot sell more than what is available within the period.
constraint
  forall(k in PRODUCTS, i in PERIODS) (
    Sell[k,i] <= (if i = 1 then 0 else Stock[k,i-1] endif) + Make[k,i]
  );

% --- Production / sales limit per product per period (as provided) ---
constraint
  forall(k in PRODUCTS, i in PERIODS) (
    Make[k,i] <= Limit[k,i] /\
    Sell[k,i] <= Limit[k,i]
  );

% --- Storage capacity per product per period (also enforced by var domain) ---
constraint
  forall(k in PRODUCTS, i in PERIODS) (
    Stock[k,i] <= 100
  );

% --- Minimum ending inventory requirement (end of each period) ---
constraint
  forall(k in PRODUCTS, i in PERIODS) (
    Stock[k,i] >= KeepQuantity[k]
  );

% --- Machine availability sanity: maintenance cannot exceed installed machines ---
constraint
  forall(i in PERIODS, m in MACHINES) (
    Maintain[i,m] <= NumMachines[m]
  );

% --- Machine capacity constraints per period ---
% Total processing time used on each machine type cannot exceed available hours:
% (number of working machines) * (24 days/month) * (WorkHours hours/day).
constraint
  forall(i in PERIODS, m in MACHINES) (
    sum(k in PRODUCTS) ( Time[k,m] * Make[k,i] )
    <= (int2float(NumMachines[m] - Maintain[i,m]) * DaysPerMonth * WorkHours)
  );

% --- Total profit definition (revenue minus storage cost) ---
constraint
  TotalProfit =
    sum(k in PRODUCTS, i in PERIODS) ( int2float(Profit[k]) * Sell[k,i] )
    - StorePrice * sum(k in PRODUCTS, i in PERIODS) ( Stock[k,i] );

% Objective
solve maximize TotalProfit;