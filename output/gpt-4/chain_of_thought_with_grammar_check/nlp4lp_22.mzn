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
array[1..K, 1..I] of var 0..100: Produce; % Quantity of each product to produce
array[1..K, 1..I] of var 0..100: Store; % Quantity of each product to store
array[1..K, 1..I] of var 0..100: Sell; % Quantity of each product to sell

% Constraints
constraint forall(k in 1..K, i in 1..I) (
  Produce[k, i] <= Limit[k, i] % Production limit
);

constraint forall(k in 1..K, i in 1..I) (
  Store[k, i] <= KeepQuantity % Storage limit
);

constraint forall(k in 1..K, i in 1..I) (
  Sell[k, i] = if i = 1 then Produce[k, i] - Store[k, i] else Produce[k, i] + Store[k, i-1] - Store[k, i] endif % Selling policy
);

constraint forall(m in 1..M, i in 1..I) (
  sum(k in 1..K) (Time[k, m] * Produce[k, i]) <= WorkHours * 24 * 6 * (NumMachines[m] - Downtime[m]) % Machine time limit
);

% Objective
var float: TotalProfit = sum(k in 1..K, i in 1..I) (Profit[k] * Sell[k, i] - StorePrice * Store[k, i]);
solve maximize TotalProfit;