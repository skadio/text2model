int: K;  % Total number of years in the planning horizon

array[1..K, 1..K] of float: InputOne;  % Production inputs from resource type one
array[1..K] of float: ManpowerOne;      % Manpower allocated to resource type one
array[1..K, 1..K] of float: InputTwo;   % Production inputs from resource type two
array[1..K] of float: ManpowerTwo;       % Manpower allocated to resource type two
array[1..K] of float: Stock;             % Stock levels of product
array[1..K] of float: Capacity;          % Production capacity for product
float: ManpowerLimit;                     % Upper limit of manpower

array[1..K] of var 0..Capacity[i]: Production;  % Production for each product in each year

% Constraints for manpower usage
var float: TotalManpower = sum(i in 1..K)(ManpowerOne[i] * Production[i] + ManpowerTwo[i] * Production[i]);

constraint TotalManpower <= ManpowerLimit;

% Constraints for production inputs
constraint forall(j in 1..K)(
    Production[j] <= Stock[j] + sum(i in 1..K)(InputOne[j, i] * Production[i]) + sum(i in 1..K)(InputTwo[j, i] * Production[i])
);

% Objective: Maximize total production in the last two years
var float: TotalProduction = Production[K-1] + Production[K];
solve maximize TotalProduction;

output [ "Total Production in last two years = ", show(TotalProduction), "\n" ];