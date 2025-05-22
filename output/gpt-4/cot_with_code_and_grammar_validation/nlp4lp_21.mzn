% Parameters
int: M; % Number of types of machines
int: K; % Number of types of products
int: I; % Number of time periods
array[1..M] of int: NumMachines; % Number of machines
array[1..K] of int: Profit; % Profit for product k
array[1..K, 1..M] of float: Time; % Time taken by product k on machine m
array[1..I, 1..M] of int: Maintain; % Maintenance time for machine m in time period i
array[1..K, 1..I] of int: Limit; % Limit of storing product k for time period i
float: StorePrice; % Price for storing products
array[1..K] of int: KeepQuantity; % Quantity of product k to keep
float: WorkHours; % Number of working hours

% Variables
array[1..K, 1..I] of var 0..100: Store; % Quantity of product k to store in time period i
array[1..K, 1..I] of var 0..100: Produce; % Quantity of product k to produce in time period i
array[1..K, 1..I] of var 0..100: Sell; % Quantity of product k to sell in time period i

% Constraints
constraint forall(k in 1..K, i in 1..I) (
  if i = 1 then
    Sell[k, i] = Produce[k, i]
  else
    Sell[k, i] = Produce[k, i] + Store[k, i-1]
  endif
);

constraint forall(k in 1..K, i in 1..I) (
  Store[k, i] = Sell[k, i] - Produce[k, i]
);

constraint forall(k in 1..K, i in 1..I) (
  Produce[k, i] <= Limit[k, i]
);

constraint forall(k in 1..K) (
  Store[k, I] >= KeepQuantity[k]
);

constraint forall(m in 1..M, i in 1..I) (
  sum(k in 1..K) (Produce[k, i] * Time[k, m]) <= (WorkHours * 24 * (NumMachines[m] - Maintain[i, m]))
);

% Objective
var float: TotalProfit = sum(k in 1..K, i in 1..I) (Profit[k] * Sell[k, i] - StorePrice * Store[k, i]);
solve maximize TotalProfit;