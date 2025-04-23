% Parameters
int: K; % Total number of years in the planning horizon
array[1..K, 1..K] of float: InputOne; % Input one coefficients matrix
array[1..K] of float: ManpowerOne; % Manpower coefficients for input one
array[1..K, 1..K] of float: InputTwo; % Input two coefficients matrix
array[1..K] of float: ManpowerTwo; % Manpower coefficients for input two
array[1..K] of float: Stock; % Initial stock level for each of the productive units
array[1..K] of float: Capacity; % Productive capacity for each productive unit
float: ManpowerLimit; % Company-wide manpower limit
array[1..K] of float: Demand; % Demand for each of the productive units at the end of the planning horizon

% Variables
var 0..ManpowerLimit: total_manpower_used; % Total manpower used across all years and industries
array[1..K, 1..K] of var 0..1: input_one_allocation; % Allocation of input one across industries and years
array[1..K, 1..K] of var 0..1: input_two_allocation; % Allocation of input two across industries and years
array[1..K] of var 0..sum(Capacity): productive_capacity; % Productive capacity for each productive unit at the end of the planning horizon
array[1..K] of var 0..sum(Stock): stock_level; % Stock level for each of the productive units at the end of the planning horizon

% Constraints

% Constraint to ensure that the total manpower used does not exceed the company-wide manpower limit
constraint total_manpower_used <= ManpowerLimit;

% Constraint to ensure that the allocation of input one and input two across industries and years does not exceed the available input
constraint forall(i in 1..K, j in 1..K) (
    input_one_allocation[i,j] <= InputOne[i,j] /\ input_two_allocation[i,j] <= InputTwo[i,j]
);

% Constraint to ensure that the productive capacity for each productive unit at the end of the planning horizon does not exceed the sum of the initial capacity and the capacity added over the years
constraint forall(i in 1..K) (
    productive_capacity[i] <= Capacity[i] + sum(j in 1..K) (input_one_allocation[i,j] + input_two_allocation[i,j])
);

% Constraint to ensure that the stock level for each of the productive units at the end of the planning horizon does not exceed the sum of the initial stock and the stock added over the years
constraint forall(i in 1..K) (
    stock_level[i] <= Stock[i] + sum(j in 1..K) (input_one_allocation[i,j] + input_two_allocation[i,j])
);

% Constraint to ensure that the demand for each of the productive units at the end of the planning horizon is met
constraint forall(i in 1..K) (
    productive_capacity[i] >= Demand[i]
);

% Constraint to ensure that the manpower used for input one and input two does not exceed the total manpower used
constraint forall(i in 1..K) (
    sum(j in 1..K) (input_one_allocation[i,j]*ManpowerOne[i] + input_two_allocation[i,j]*ManpowerTwo[i]) <= total_manpower_used
);

% Objective
solve maximize sum(i in 1..K) (productive_capacity[i]);