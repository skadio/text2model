% Parameters
int: M;                           % Number of machine types
int: K;                           % Number of product types
int: I;                           % Number of time periods (months)

set of int: MACHINES = 1..M;      % Machine index set
set of int: PRODUCTS = 1..K;      % Product index set
set of int: PERIODS  = 1..I;      % Time period index set

array[MACHINES] of int: NumMachines;                 % Count of machines of each type
array[PRODUCTS] of int: Profit;                      % Profit per unit sold for each product
array[PRODUCTS, MACHINES] of float: Time;            % Machine-hours needed per unit of product on machine
array[PERIODS, MACHINES] of int: Downtime;           % Number of machines down in each period (by machine type)
array[PRODUCTS, PERIODS] of int: Limit;              % Max production allowed of product in each period

float: StorePrice;                % Storage cost per unit per month
int: KeepQuantity;                % Required minimum end-of-month stock (each product, each month)
float: WorkHours;                 % Hours per shift-day

% Variables
% Production/sales bounded by the maximum limit value in the input matrix.
array[PRODUCTS, PERIODS] of var 0..max(Limit): make;  % Units manufactured of each product in each period
array[PRODUCTS, PERIODS] of var 0..max(Limit): sell;  % Units sold of each product in each period

% Stock at end of each period; capped by storage capacity (100 units per product)
array[PRODUCTS, PERIODS] of var 0..100: stock;        % End-of-period inventory for each product

% Helper variable for storage cost calculation (equals stock here)
array[PRODUCTS, PERIODS] of var 0..100: stored;       % Units held in storage during the period

% Constraints

% --- Production limits per product and period (given by input Limit) ---
constraint
  forall(p in PRODUCTS, t in PERIODS) (
    make[p,t] <= Limit[p,t]
  );

% --- Inventory flow conservation (no initial stock) ---
% End-of-period stock equals previous stock + manufactured - sold.
constraint
  forall(p in PRODUCTS, t in PERIODS) (
    stock[p,t] =
      (if t = 1 then 0 else stock[p,t-1] endif)
      + make[p,t] - sell[p,t]
  );

% --- Cannot sell more than available inventory (redundant but clarifies intent) ---
constraint
  forall(p in PRODUCTS, t in PERIODS) (
    sell[p,t] <= (if t = 1 then 0 else stock[p,t-1] endif) + make[p,t]
  );

% --- Storage accounting (units held in storage during the period) ---
constraint
  forall(p in PRODUCTS, t in PERIODS) (
    stored[p,t] = stock[p,t]
  );

% --- Storage capacity already enforced by variable domain; kept explicitly for clarity ---
constraint
  forall(p in PRODUCTS, t in PERIODS) (
    stock[p,t] <= 100
  );

% --- Minimum end-of-period stock requirement (from period 2 onwards) ---
constraint
  forall(p in PRODUCTS, t in PERIODS where t > 1) (
    stock[p,t] >= KeepQuantity
  );

% --- Machine capacity constraints per period (account for downtime) ---
% Available machine-hours = (machines not down) * (24 days/month) * (2 shifts/day) * WorkHours
constraint
  forall(t in PERIODS, m in MACHINES) (
    sum(p in PRODUCTS) ( Time[p,m] * int2float(make[p,t]) )
    <=
    int2float(NumMachines[m] - Downtime[t,m]) * (24.0 * 2.0 * WorkHours)
  );

% --- Feasibility of downtime counts (cannot have more machines down than exist) ---
constraint
  forall(t in PERIODS, m in MACHINES) (
    Downtime[t,m] <= NumMachines[m]
  );

% Objective
solve maximize
  sum(p in PRODUCTS, t in PERIODS) (
    int2float(Profit[p]) * int2float(sell[p,t])
    - StorePrice * int2float(stored[p,t])
  );