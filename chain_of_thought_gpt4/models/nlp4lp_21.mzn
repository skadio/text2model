% Parameters
int: M; % Number of types of machines
int: K; % Number of types of products
int: I; % Number of time periods
array[1..M] of float: NumMachines; % Number of machines
array[1..K] of float: Profit; % Profit for product k
array[1..K, 1..M] of float: Time; % Time taken by product k on machine m
array[1..I, 1..M] of int: Maintain; % Maintenance time for machine m in time period i
array[1..K, 1..I] of int: Limit; % Limit of storing product k for time period i
float: StorePrice; % Price for storing products
int: KeepQuantity; % Quantity of product k to keep
float: WorkHours; % Number of working hours

% Variables
array[1..K, 1..I] of var 0..max(Limit): Produce; % Quantity of product k produced in time period i
array[1..K, 1..I] of var 0..max(Limit): Store; % Quantity of product k stored in time period i
array[1..K, 1..I] of var 0..max(Limit): Sell; % Quantity of product k sold in time period i

% Constraints
constraint forall(k in 1..K, i in 1..I) (
  if i = 1 then
    Sell[k, i] = min(Produce[k, i], KeepQuantity)
  else
    Sell[k, i] = min(Produce[k, i] + Store[k, i-1], Limit[k, i])
  endif
);

constraint forall(k in 1..K, i in 1..I) (
  if i = 1 then
    Store[k, i] = KeepQuantity
  else
    Store[k, i] = Produce[k, i] + Store[k, i-1] - Sell[k, i]
  endif
);

constraint forall(k in 1..K) (
  Store[k, I] >= KeepQuantity
);

constraint forall(m in 1..M, i in 1..I) (
  sum(k in 1..K) (Produce[k, i] * Time[k, m]) <= (WorkHours * 24 * (NumMachines[m] - Maintain[i, m]))
);

% Objective
var float: TotalProfit = sum(k in 1..K, i in 1..I) (Profit[k] * Sell[k, i] - StorePrice * Store[k, i]);

solve maximize TotalProfit;