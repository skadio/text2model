include "globals.mzn";

int: M;                          % Number of types of machines
int: K;                          % Number of types of products
int: I;                          % Number of time periods
array[1..M] of int: NumMachines; % Number of machines
array[1..K] of int: Profit;      % Profit for each product
array[1..K, 1..M] of float: Time; % Time required to produce each product on each machine
array[1..M, 1..I] of int: Downtime; % Downtime for each machine
array[1..K, 1..I] of int: Limit; % Limit for each product on constraints
float: StorePrice;               % Price for storing products
int: KeepQuantity;               % Quantity of products to keep in store
float: WorkHours;                % Number of work hours available

% Decision variables
array[1..K, 1..I] of var 0..max(Limit): Production; % Production quantities for each product in each period
array[1..K, 1..I] of var 0..KeepQuantity: Stock;    % Stock levels for each product in each period

% Constraints
% Ensure production does not exceed limits
constraint forall(k in 1..K, i in 1..I) (
    Production[k, i] <= Limit[k, i]
);

% Calculate available working hours per machine
array[1..M] of var 0..WorkHours: AvailableHours; % Available hours for each machine

% Calculate total production time for each product on each machine
array[1..M, 1..I] of var 0..WorkHours: TotalProductionTime; % Total production time for each machine in each period

% Ensure production time does not exceed available hours
constraint forall(m in 1..M, i in 1..I) (
    TotalProductionTime[m, i] = sum(k in 1..K)(Time[k, m] * Production[k, i]) 
    -> TotalProductionTime[m, i] <= AvailableHours[m]
);

% Objective function: Maximize profit
var float: TotalProfit = sum(k in 1..K, i in 1..I)(Profit[k] * Production[k, i]) - sum(k in 1..K, i in 1..I)(StorePrice * (Stock[k, i] - KeepQuantity));

solve maximize TotalProfit;

% Output
output [
    "Total Profit = ", show(TotalProfit), "\n",
    "Production = ", show(Production), "\n",
    "Stock = ", show(Stock), "\n"
];