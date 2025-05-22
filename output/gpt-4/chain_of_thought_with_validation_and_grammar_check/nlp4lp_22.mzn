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
array[1..K, 1..I] of var 0..100: Store; % Quantity of each product to store in each month
array[1..K, 1..I] of var 0..100: Produce; % Quantity of each product to produce in each month
array[1..K, 1..I] of var 0..100: Sell; % Quantity of each product to sell in each month

% Constraints
% The quantity of each product to produce in each month should not exceed the limit
constraint forall(k in 1..K, i in 1..I)(Produce[k,i] <= Limit[k,i]);

% The quantity of each product to store in each month should not exceed the keep quantity
constraint forall(k in 1..K, i in 1..I)(Store[k,i] <= KeepQuantity);

% The quantity of each product to sell in each month should not exceed the quantity produced and stored
constraint forall(k in 1..K, i in 1..I)(Sell[k,i] <= Produce[k,i] + if i > 1 then Store[k,i-1] else 0 endif);

% The quantity of each product to store in each month should be the quantity produced and stored minus the quantity sold
constraint forall(k in 1..K, i in 1..I)(Store[k,i] = Produce[k,i] + if i > 1 then Store[k,i-1] else 0 endif - Sell[k,i]);

% The total time to produce all products in each month should not exceed the work hours available
constraint forall(i in 1..I)(sum(k in 1..K)(Produce[k,i] * Time[k, sum(j in 1..M)(if i <= Downtime[j] then 0 else NumMachines[j] endif)]) <= WorkHours * 24 * 6);

% Objective
var float: TotalProfit = sum(k in 1..K, i in 1..I)(Profit[k] * Sell[k,i] - StorePrice * Store[k,i]);
solve maximize TotalProfit;