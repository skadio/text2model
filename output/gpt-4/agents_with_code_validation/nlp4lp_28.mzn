% Parameters
int: K; % Total number of years in the planning horizon
array[1..K, 1..K] of float: InputOne; % The production inputs from resource type one to product k in year j
array[1..K] of float: ManpowerOne; % The manpower allocated to resource type one for product k
array[1..K, 1..K] of float: InputTwo; % The production inputs from resource type two to product k in year j
array[1..K] of float: ManpowerTwo; % The manpower allocated to resource type two for product k
array[1..K] of float: Stock; % Stock levels of product k at the start of the planning horizon
array[1..K] of float: Capacity; % Production capacity for product k
float: ManpowerLimit; % The upper limit of manpower

% Variables
var 0..ManpowerLimit: total_manpower; % Total manpower used in the economy
array[1..K] of var 0..ManpowerLimit: manpower_allocation; % Manpower allocation for each year
array[1..K, 1..K] of var 0..float: production; % Production of each product in each year
array[1..K] of var 0..float: stock_levels; % Stock levels of each product at the end of each year
array[1..K] of var 0..float: capacity_levels; % Capacity levels of each product at the end of each year

% Constraints

% The total manpower used in the economy should not exceed the manpower limit
constraint total_manpower <= ManpowerLimit;

% The manpower allocation for each year should be equal to the total manpower used in the economy
constraint forall(i in 1..K) (
    manpower_allocation[i] = total_manpower
);

% The production of each product in each year should not exceed the capacity of that product
constraint forall(i in 1..K, j in 1..K) (
    production[i,j] <= Capacity[j]
);

% The production of each product in each year should be less than or equal to the sum of the inputs from resource type one and two and the stock levels of that product at the start of the year
constraint forall(i in 1..K, j in 1..K) (
    production[i,j] <= InputOne[i,j] + InputTwo[i,j] + Stock[j]
);

% The manpower allocated to resource type one for product k should not exceed the manpower limit
constraint forall(i in 1..K) (
    ManpowerOne[i] <= ManpowerLimit
);

% The manpower allocated to resource type two for product k should not exceed the manpower limit
constraint forall(i in 1..K) (
    ManpowerTwo[i] <= ManpowerLimit
);

% The stock levels of each product at the end of each year should be less than or equal to the production of that product in that year plus the stock levels of that product at the start of the year
constraint forall(i in 1..K) (
    stock_levels[i] <= production[i,i] + Stock[i]
);

% The capacity levels of each product at the end of each year should be less than or equal to the production of that product in that year plus the capacity of that product at the start of the year
constraint forall(i in 1..K) (
    capacity_levels[i] <= production[i,i] + Capacity[i]
);

% Objective
solve maximize sum(i in 1..K) (production[i,K-1] + production[i,K]);