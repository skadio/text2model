% Parameters
int: M; % Number of types of machines
int: K; % Number of types of products
int: I; % Number of time periods
array[1..M] of int: NumMachines; % Number of machines of each type
array[1..K] of int: Profit; % Profit for each product
array[1..K, 1..M] of int: Time; % Time taken by each product on each machine
array[1..I, 1..M] of int: Maintain; % Maintenance time for each machine in each time period
array[1..K, 1..I] of int: Limit; % Limit of storing each product for each time period
int: StorePrice; % Price for storing products
array[1..K] of int: KeepQuantity; % Quantity of each product to keep
int: WorkHours; % Number of working hours

% Variables
array[1..K, 1..I] of var 0..100: Store; % Quantity of each product to store in each time period
array[1..K, 1..I] of var 0..100: Produce; % Quantity of each product to produce in each time period
array[1..K, 1..I] of var 0..100: Sell; % Quantity of each product to sell in each time period

% Constraints

% The quantity of each product to store in each time period should be less than or equal to the limit of storing each product for each time period
constraint forall(k in 1..K, i in 1..I) (
    Store[k,i] <= Limit[k,i]
);

% The quantity of each product to produce in each time period should be less than or equal to the limit of storing each product for each time period
constraint forall(k in 1..K, i in 1..I) (
    Produce[k,i] <= Limit[k,i]
);

% The quantity of each product to sell in each time period should be less than or equal to the quantity of each product to produce in each time period
constraint forall(k in 1..K, i in 1..I) (
    Sell[k,i] <= Produce[k,i]
);

% The quantity of each product to store in each time period should be less than or equal to the quantity of each product to produce in each time period minus the quantity of each product to sell in each time period
constraint forall(k in 1..K, i in 1..I) (
    Store[k,i] <= Produce[k,i] - Sell[k,i]
);

% The total time taken by all products on all machines in each time period should be less than or equal to the total working hours minus the maintenance time for each machine in each time period
constraint forall(i in 1..I) (
    sum(k in 1..K, m in 1..M) (Time[k,m] * Produce[k,i]) <= WorkHours * 24 * 6 * sum(m in 1..M) (NumMachines[m] - Maintain[i,m])
);

% The quantity of each product to store in the last time period should be greater than or equal to the quantity of each product to keep
constraint forall(k in 1..K) (
    Store[k,I] >= KeepQuantity[k]
);

% Objective
solve maximize sum(k in 1..K, i in 1..I) (Profit[k] * Sell[k,i] - StorePrice * Store[k,i]);