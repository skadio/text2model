% Parameters
int: M; % Number of types of machines
int: K; % Number of types of products
int: I; % Number of time periods
array[1..M] of int: NumMachines; % Number of machines
array[1..K] of int: Profit; % Profit for each product
array[1..K, 1..M] of int: Time; % Time required to produce each product on each machine
array[1..M] of int: Downtime; % Downtime for each machine
array[1..K, 1..I] of int: Limit; % Limit for each product on constraints
int: StorePrice; % Price for storing products
int: KeepQuantity; % Quantity of products to keep in store
int: WorkHours; % Number of work hours available

% Variables
array[1..K, 1..I] of var 0..100: Store; % Quantity of each product to store in each month
array[1..K, 1..I] of var 0..100: Produce; % Quantity of each product to produce in each month
array[1..K, 1..I] of var 0..100: Sell; % Quantity of each product to sell in each month

% Constraints

% The quantity of each product to store in each month should be less than or equal to the limit for each product
constraint forall(k in 1..K, i in 1..I) (
    Store[k, i] <= Limit[k, i]
);

% The quantity of each product to produce in each month should be less than or equal to the limit for each product
constraint forall(k in 1..K, i in 1..I) (
    Produce[k, i] <= Limit[k, i]
);

% The quantity of each product to sell in each month should be less than or equal to the quantity of each product to produce in each month
constraint forall(k in 1..K, i in 1..I) (
    Sell[k, i] <= Produce[k, i]
);

% The quantity of each product to store in each month should be less than or equal to the quantity of each product to produce in each month minus the quantity of each product to sell in each month
constraint forall(k in 1..K, i in 1..I) (
    Store[k, i] <= Produce[k, i] - Sell[k, i]
);

% The quantity of each product to store in each month should be greater than or equal to the minimum stock that should be stored of each type of product
constraint forall(k in 1..K, i in 1..I) (
    Store[k, i] >= KeepQuantity
);

% The total time required to produce all products on all machines in each month should be less than or equal to the number of work hours available minus the downtime for each machine
constraint forall(i in 1..I) (
    sum(k in 1..K, m in 1..M) (Time[k, m] * ceil(int2float(Produce[k, i]) / int2float(Time[k, m]))) <= WorkHours - sum(m in 1..M) (Downtime[m] * NumMachines[m])
);

% The total number of machines used in each month should be less than or equal to the number of machines available
constraint forall(i in 1..I) (
    sum(m in 1..M) (sum(k in 1..K) (if Time[k, m] * Produce[k, i] > 0 then ceil(int2float(Produce[k, i]) / int2float(Time[k, m])) else 0 endif)) <= sum(m in 1..M) (NumMachines[m] - Downtime[m])
);

% Objective
solve maximize sum(k in 1..K, i in 1..I) (Profit[k] * Sell[k, i] - StorePrice * Store[k, i]);