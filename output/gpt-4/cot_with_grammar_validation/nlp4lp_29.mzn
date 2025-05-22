% Parameters
int: K;
array[1..K] of float: ManpowerOne;
array[1..K] of float: ManpowerTwo;
array[1..K] of int: Stock;
array[1..K] of int: Capacity;
array[1..K] of float: Demand;
array[1..K, 1..K] of float: InputOne;
array[1..K, 1..K] of float: InputTwo;

% Variables
array[1..K] of var 0..sum(Capacity): Production;
array[1..K] of var 0..sum(Stock): StockLevel;
array[1..K] of var 0..sum(Capacity): CapacityLevel;

% Constraints
constraint forall(k in 1..K) (
    Production[k] <= Capacity[k] + Stock[k-1] % Production cannot exceed capacity and stock from previous year
);
constraint forall(k in 1..K) (
    StockLevel[k] = Stock[k] + Production[k] - Demand[k] % Stock level is previous stock plus production minus demand
);
constraint forall(k in 1..K) (
    CapacityLevel[k] = Capacity[k] + sum(j in 1..K) (InputOne[k,j]*Production[j]) % Capacity level is previous capacity plus input from all industries
);
constraint forall(k in 1..K) (
    sum(j in 1..K) (InputTwo[k,j]*Production[j]) <= ManpowerOne[k] + ManpowerTwo[k] % Manpower requirement cannot exceed the sum of manpower from both operations
);

% Objective
var float: TotalManpower = sum(k in 1..K) (ManpowerOne[k] + ManpowerTwo[k]);
solve maximize TotalManpower;