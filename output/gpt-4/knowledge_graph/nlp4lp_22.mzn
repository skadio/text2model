include "globals.mzn";

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

% Constraints
constraint forall(k in 1..K, i in 1..I) (
  Produce[k, i] <= Limit[k, i]
);

constraint forall(k in 1..K, i in 1..I) (
  if i > 1 then
    Store[k, i] = Store[k, i-1] + Produce[k, i] - KeepQuantity
  else
    Store[k, i] = Produce[k, i] - KeepQuantity
  endif
);

constraint forall(m in 1..M) (
  sum(k in 1..K, i in 1..I) (Time[k, m] * Produce[k, i]) <= WorkHours * (24 * (I - Downtime[m]))
);

% Objective
var int: TotalProfit = sum(k in 1..K, i in 1..I) (Profit[k] * (Produce[k, i] - Store[k, i] * StorePrice));
solve maximize TotalProfit;

% Output
output [ "Total Profit: " ++ show(TotalProfit) ++ "\n" ] ++
[ if fix(Produce[k, i]) > 0 then "Produce " ++ show(Produce[k, i]) ++ " of product " ++ show(k) ++ " in month " ++ show(i) ++ "\n" else "" endif | k in 1..K, i in 1..I ] ++
[ if fix(Store[k, i]) > 0 then "Store " ++ show(Store[k, i]) ++ " of product " ++ show(k) ++ " in month " ++ show(i) ++ "\n" else "" endif | k in 1..K, i in 1..I ];