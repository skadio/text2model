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
array[1..K] of var 0..ManpowerLimit: manpower_allocation; % Manpower allocation for each product k
array[1..K, 1..K] of var 0..Capacity[i]: production; % Production of each product k in each year j
array[1..K] of var 0..Stock[i]: stock_levels; % Stock levels of each product k at the end of the planning horizon

% Constraints

% Constraint 1: The total manpower used in the economy should not exceed the manpower limit
constraint total_manpower <= ManpowerLimit;

% Constraint 2: The manpower allocation for each product should not exceed the total manpower
constraint forall(i in 1..K) (
    manpower_allocation[i] <= total_manpower
);

% Constraint 3: The production of each product in each year should not exceed the capacity of that product
constraint forall(i in 1..K, j in 1..K) (
    production[i,j] <= Capacity[i]
);

% Constraint 4: The stock levels of each product at the end of the planning horizon should not exceed the initial stock levels
constraint forall(i in 1..K) (
    stock_levels[i] <= Stock[i]
);

% Constraint 5: The production inputs from resource type one to product k in year j should not exceed the production of that product in that year
constraint forall(i in 1..K, j in 1..K) (
    InputOne[i,j] <= production[i,j]
);

% Constraint 6: The production inputs from resource type two to product k in year j should not exceed the production of that product in that year
constraint forall(i in 1..K, j in 1..K) (
    InputTwo[i,j] <= production[i,j]
);

% Constraint 7: The manpower allocated to resource type one for product k should not exceed the total manpower
constraint forall(i in 1..K) (
    ManpowerOne[i] <= total_manpower
);

% Constraint 8: The manpower allocated to resource type two for product k should not exceed the total manpower
constraint forall(i in 1..K) (
    ManpowerTwo[i] <= total_manpower
);

% Objective
solve maximize sum(i in 1..K)(production[i,K] + production[i,K-1]);