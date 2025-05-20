include "globals.mzn";

% Parameters
int: K; % Total number of years in the planning horizon
array[1..K, 1..K] of float: InputOne; % The production inputs from resource type one to product k in year j
array[1..K] of float: ManpowerOne; % The manpower allocated to resource type one for product k
array[1..K, 1..K] of float: InputTwo; % The production inputs from resource type two to product k in year j
array[1..K] of float: ManpowerTwo; % The manpower allocated to resource type two for product k
array[1..K] of int: Stock; % Stock levels of product k at the start of the planning horizon
array[1..K] of int: Capacity; % Production capacity for product k
float: ManpowerLimit; % The upper limit of manpower

% Decision variables
array[1..K] of var 0..Capacity[i]: Production; % Production for each year
array[1..K] of var 0..Stock[i]: StockEnd; % Stock at the end of each year

% Objective: Maximize total production in the last two years
var int: obj = sum(i in 1..K)(Production[i]);
maximize obj;

% Constraints
constraint forall(i in 1..K)(
  sum(j in 1..K)(InputOne[i,j]*Production[j] + InputTwo[i,j]*Production[j]) + ManpowerOne[i] + ManpowerTwo[i] <= ManpowerLimit
);

constraint forall(i in 1..K)(
  Production[i] <= Capacity[i]
);

constraint forall(i in 1..K)(
  StockEnd[i] = Stock[i] + Production[i] - sum(j in 1..K)(InputOne[i,j]*Production[j] + InputTwo[i,j]*Production[j])
);

constraint forall(i in 1..K)(
  StockEnd[i] >= 0
);