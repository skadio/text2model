include "globals.mzn";

% Parameters
int: M; % Number of types of machines
int: K; % Number of types of products
int: I; % Number of time periods
array[1..M] of int: NumMachines; % Number of machines
array[1..K] of int: Profit; % Profit for product k
array[1..K, 1..M] of float: Time; % Time taken by product k on machine m
array[1..M, 1..I] of int: Maintain; % Maintenance time for machine m in time period i
array[1..K, 1..I] of int: Limit; % Limit of storing product k for time period i
float: StorePrice; % Price for storing products
array[1..K] of int: KeepQuantity; % Quantity of product k to keep
float: WorkHours; % Number of working hours

% Variables
array[1..K, 1..I] of var 0..Limit: Produce; % Quantity of product k to produce in time period i
array[1..K, 1..I] of var 0..Limit: Store; % Quantity of product k to store in time period i

% Constraints
constraint forall(i in 1..I, m in 1..M) (
    sum(k in 1..K) (Time[k, m] * Produce[k, i]) <= WorkHours * (NumMachines[m] - Maintain[m, i]) * 24
);

constraint forall(i in 1..I, k in 1..K) (
    if i > 1 then
        Produce[k, i] + Store[k, i-1] <= Limit[k, i] + Store[k, i]
    else
        Produce[k, i] <= Limit[k, i] + Store[k, i]
    endif
);

constraint forall(k in 1..K) (
    Store[k, I] >= KeepQuantity[k]
);

% Objective
var int: TotalProfit;
constraint TotalProfit = sum(i in 1..I, k in 1..K) (Profit[k] * Produce[k, i] - StorePrice * Store[k, i]);
solve maximize TotalProfit;

% Output
output [ "Total Profit: " ++ show(TotalProfit) ++ "\n" ] ++
[ if fix(Produce[k, i]) > 0 then "Produce " ++ show(Produce[k, i]) ++ " of product " ++ show(k) ++ " in month " ++ show(i) ++ "\n" else "" endif | i in 1..I, k in 1..K] ++
[ if fix(Store[k, i]) > 0 then "Store " ++ show(Store[k, i]) ++ " of product " ++ show(k) ++ " in month " ++ show(i) ++ "\n" else "" endif | i in 1..I, k in 1..K];