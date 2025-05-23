include "globals.mzn";

% Parameters
int: K; % The number of years over which the total manpower requirement is maximized
array[1..K] of float: ManpowerOne; % Manpower requirements for operations one in year k
array[1..K] of float: ManpowerTwo; % Manpower requirements for operations two in year k
array[1..K] of int: Stock; % Stock level of product k at the beginning of the year
array[1..K] of int: Capacity; % Production capacity for product k for the year
array[1..K] of float: Demand; % Demand for product k for the year
array[1..K, 1..K] of float: InputOne; % Input one coefficient for product k with respect to product j
array[1..K, 1..K] of float: InputTwo; % Input two coefficient for product k with respect to product j

% Variables
array[1..K] of var 0..Capacity[i]: Production; % Production for product k for the year
array[1..K] of var 0..Stock[i]: StockUsed; % Stock used for product k for the year

% Constraints
constraint forall(i in 1..K) (
    Production[i] <= Capacity[i] % Production cannot exceed capacity
);

constraint forall(i in 1..K) (
    StockUsed[i] <= Stock[i] % Stock used cannot exceed stock available
);

constraint forall(i in 1..K) (
    Production[i] + StockUsed[i] >= Demand[i] % Production plus stock used must meet demand
);

constraint forall(i in 1..K, j in 1..K) (
    Production[i] * InputOne[i,j] + StockUsed[i] * InputTwo[i,j] <= Capacity[j] % Input requirements must not exceed capacity
);

% Objective
var float: TotalManpower;
constraint TotalManpower = sum(i in 1..K) (Production[i] * ManpowerOne[i] + StockUsed[i] * ManpowerTwo[i]);
solve maximize TotalManpower;

% Output
output [ "Total Manpower: " ++ show(TotalManpower) ++ "\n" ];