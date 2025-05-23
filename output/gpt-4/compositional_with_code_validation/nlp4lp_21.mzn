% Parameters
int: M; % Number of types of machines
int: K; % Number of types of products
int: I; % Number of time periods
array[1..M] of int: NumMachines; % Number of machines of each type
array[1..K] of int: Profit; % Profit for each product
array[1..K, 1..M] of int: Time; % Time taken by each product on each machine
array[1..I, 1..M] of int: Maintain; % Maintenance time for each machine in each time period
array[1..K, 1..I] of int: Limit; % Limit of producing each product for each time period
int: StorePrice; % Price for storing products
array[1..K] of int: KeepQuantity; % Quantity of each product to keep
int: WorkHours; % Number of working hours

% Variables
array[1..K, 1..I] of var 0..100: Store; % Quantity of each product to store in each time period
array[1..K, 1..I] of var 0..100: Produce; % Quantity of each product to produce in each time period
array[1..K, 1..I] of var 0..100: Sell; % Quantity of each product to sell in each time period

% Constraints

% The quantity of each product to produce in each time period should be less than or equal to the limit
constraint forall(k in 1..K, i in 1..I)(Produce[k,i] <= Limit[k,i]);

% The quantity of each product to store in each time period should be greater than or equal to the quantity to keep
constraint forall(k in 1..K, i in 1..I)(Store[k,i] >= KeepQuantity[k]);

% The total time taken by all products on all machines in each time period should be less than or equal to the total working hours minus the maintenance time
constraint forall(i in 1..I)(
  sum(k in 1..K, m in 1..M)(Time[k,m] * Produce[k,i]) <= WorkHours * 24 * 6 * sum(m in 1..M)(NumMachines[m] - Maintain[i,m])
);

% The quantity of each product to sell in the first time period should be less than or equal to the quantity to produce
constraint forall(k in 1..K)(Sell[k,1] <= Produce[k,1]);

% The quantity of each product to store in the first time period should be equal to the quantity to produce minus the quantity to sell
constraint forall(k in 1..K)(Store[k,1] = Produce[k,1] - Sell[k,1]);

% For subsequent time periods, the quantity of each product to sell should be less than or equal to the quantity to produce plus the quantity to store from the previous time period minus the quantity to sell in the previous time period
constraint forall(k in 1..K, i in 2..I)(Sell[k,i] <= Produce[k,i] + Store[k,i-1] - Sell[k,i-1]);

% For subsequent time periods, the quantity of each product to store should be equal to the quantity to produce plus the quantity to store from the previous time period minus the quantity to sell
constraint forall(k in 1..K, i in 2..I)(Store[k,i] = Produce[k,i] + Store[k,i-1] - Sell[k,i]);

% Objective
solve maximize sum(k in 1..K, i in 1..I)(Profit[k] * Sell[k,i] - StorePrice * Store[k,i]);