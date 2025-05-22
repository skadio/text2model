% Parameters
int: M; % Number of types of machines
int: K; % Number of types of products
int: I; % Number of time periods
array[1..M] of int: NumMachines; % Number of machines
array[1..K] of int: Profit; % Profit for each product
array[1..K, 1..M] of float: Time; % Time required to produce each product on each machine
array[1..M] of int: Downtime; % Downtime for each machine
array[1..K, 1..I] of int: Limit; % Limit for each product on constraints
float: StorePrice; % Price for storing products
int: KeepQuantity; % Quantity of products to keep in store
float: WorkHours; % Number of work hours available

% Variables
array[1..K, 1..I] of var 0..1000: Store; % Quantity of each product to store in each month
array[1..K, 1..I] of var 0..1000: Sell; % Quantity of each product to sell in each month
array[1..K, 1..I] of var 0..1000: Manufacture; % Quantity of each product to manufacture in each month

% Constraints
constraint forall(k in 1..K, i in 1..I) (
  if i = 1 then
    Store[k, i] = Manufacture[k, i] - Sell[k, i]
  else
    Store[k, i] = Store[k, i-1] + Manufacture[k, i] - Sell[k, i]
  endif
);

constraint forall(k in 1..K, i in 1..I) (
  Manufacture[k, i] <= Limit[k, i]
);

constraint forall(k in 1..K, i in 1..I) (
  Store[k, i] <= KeepQuantity
);

constraint forall(m in 1..M, i in 1..I) (
  sum(k in 1..K) (Time[k, m] * Manufacture[k, i]) <= WorkHours * 24 * 6 * (NumMachines[m] - Downtime[m])
);

% Objective
var float: TotalProfit = sum(k in 1..K, i in 1..I) (Profit[k] * Sell[k, i] - StorePrice * Store[k, i]);
solve maximize TotalProfit;