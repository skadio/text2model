% Parameters
int: M; % number of machine types
int: K; % number of product types
int: I; % number of time periods

array[1..M] of int: NumMachines; % machines available per type
array[1..K] of int: Profit; % profit per unit of product k
array[1..K, 1..M] of float: Time; % time required on machine m for product k
array[1..I, 1..M] of float: Maintain; % maintenance time for machine m in period i
array[1..K, 1..I] of int: Limit; % production limit of product k in period i
float: StorePrice; % storage cost per unit per period
array[1..K] of int: KeepQuantity; % minimum ending inventory for each product
float: WorkHours; % working hours per day

% Derived constants
float: PeriodHours = WorkHours * 24.0; % hours available in a period before maintenance

% Variables
array[1..I, 1..K] of var 0..Limit[k,i] of int: prod; % production quantity
array[1..I, 1..K] of var 0..Limit[k,i] of int: sell; % selling quantity
array[0..I, 1..K] of var KeepQuantity[k]..100 of int: stock; % ending inventory

% Constraints
constraint
  % Initial inventory is zero
  forall(k in 1..K) (
    stock[0,k] = 0
  ) /\
  % Machine capacity constraints
  forall(i in 1..I, m in 1..M) (
    sum(k in 1..K) (prod[i,k] * Time[k,m]) <=
      NumMachines[m] * (PeriodHours - Maintain[i,m])
  ) /\
  % Stock dynamics
  forall(i in 1..I, k in 1..K) (
    stock[i,k] = stock[i-1,k] + prod[i,k] - sell[i,k]
  ) /\
  % Selling cannot exceed available inventory
  forall(i in 1..I, k in 1..K) (
    sell[i,k] <= stock[i-1,k] + prod[i,k]
  ) /\
  % Minimum ending inventory
  forall(i in 1..I, k in 1..K) (
    stock[i,k] >= KeepQuantity[k]
  );

% Objective
solve maximize
  sum(i in 1..I, k in 1..K) (sell[i,k] * Profit[k]) -
  sum(i in 1..I, k in 1..K) (stock[i,k] * StorePrice);