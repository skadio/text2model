% Parameters
int: K; % The number of years over which the total manpower requirement is maximized
array[1..K] of float: ManpowerOne; % Manpower requirements for operations one in year k
array[1..K] of float: ManpowerTwo; % Manpower requirements for operations two in year k
array[1..K] of float: Stock; % Stock level of product k at the beginning of the year
array[1..K] of float: Capacity; % Production capacity for product k for the year
array[1..K] of float: Demand; % Demand for product k for the year
array[1..K, 1..K] of float: InputOne; % Input one coefficient for product k with respect to product j
array[1..K, 1..K] of float: InputTwo; % Input two coefficient for product k with respect to product j

% Variables
var float: total_manpower; % Total manpower requirement over the years
array[1..K] of var 0..K: strategy; % Strategy to be followed for each year

% Constraints

% The total manpower requirement is the sum of the manpower requirements for operations one and two over the years
constraint total_manpower = sum(k in 1..K) (ManpowerOne[k] + ManpowerTwo[k]);

% The strategy for each year must be such that the production capacity for the year is not exceeded
constraint forall(k in 1..K) (strategy[k] <= Capacity[k]);

% The strategy for each year must be such that the demand for the year is met
constraint forall(k in 1..K) (strategy[k] >= Demand[k]);

% The strategy for each year must be such that the stock level at the beginning of the year is not exceeded
constraint forall(k in 1..K) (strategy[k] <= Stock[k]);

% The input one coefficient for product k with respect to product j must be less than or equal to the strategy for year j
constraint forall(k in 1..K, j in 1..K) (InputOne[k,j] <= strategy[j]);

% The input two coefficient for product k with respect to product j must be less than or equal to the strategy for year j
constraint forall(k in 1..K, j in 1..K) (InputTwo[k,j] <= strategy[j]);

% The strategy for each year must be such that the input from an industry in year t results in a (permanent) increase in productive capacity in year t + 2
constraint forall(k in 1..K-2) (strategy[k] <= Capacity[k+2]);

% Objective
solve maximize total_manpower;