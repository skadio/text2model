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
array[1..K, 1..K] of var 0.0..float: InputOneAllocation; % Allocation of input one for each industry in each year
array[1..K, 1..K] of var 0.0..float: InputTwoAllocation; % Allocation of input two for each industry in each year
array[1..K] of var 0.0..float: ManpowerAllocationOne; % Manpower allocation for input one in each year
array[1..K] of var 0.0..float: ManpowerAllocationTwo; % Manpower allocation for input two in each year
array[1..K] of var 0.0..float: StockLevel; % Stock level for each industry in each year
array[1..K] of var 0.0..float: CapacityLevel; % Capacity level for each industry in each year

% Constraints

% The total allocation of input one for each industry in each year should not exceed the available stock
constraint forall(i in 1..K)(
  sum(j in 1..K)(InputOneAllocation[i,j]) <= Stock[i]
);

% The total allocation of input two for each industry in each year should not exceed the available stock
constraint forall(i in 1..K)(
  sum(j in 1..K)(InputTwoAllocation[i,j]) <= Stock[i]
);

% The total manpower allocation for input one in each year should not exceed the manpower limit
constraint forall(i in 1..K)(
  ManpowerAllocationOne[i] * ManpowerOne[i] <= ManpowerLimit
);

% The total manpower allocation for input two in each year should not exceed the manpower limit
constraint forall(i in 1..K)(
  ManpowerAllocationTwo[i] * ManpowerTwo[i] <= ManpowerLimit
);

% The stock level for each industry in each year should be equal to the initial stock plus the sum of input one and input two allocations minus the demand
constraint forall(i in 1..K)(
  StockLevel[i] = Stock[i] + sum(j in 1..K)(InputOneAllocation[i,j] + InputTwoAllocation[i,j]) - Demand[i]
);

% The capacity level for each industry in each year should be equal to the initial capacity plus the sum of input one and input two allocations
constraint forall(i in 1..K)(
  CapacityLevel[i] = Capacity[i] + sum(j in 1..K)(InputOneAllocation[i,j] + InputTwoAllocation[i,j])
);

% The total productive capacity at the end of the five years should be maximized
constraint forall(i in 1..K)(
  CapacityLevel[i] >= sum(j in 1..K)(InputOneAllocation[i,j] + InputTwoAllocation[i,j])
);

% Objective
solve maximize sum(i in 1..K)(CapacityLevel[i]);