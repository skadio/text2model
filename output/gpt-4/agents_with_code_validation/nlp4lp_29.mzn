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
array[1..K] of var 0.0..float: strategy; % Strategy to be followed for each year

% Constraints

% The total manpower requirement is the sum of the manpower requirements for operations one and two over the years
constraint total_manpower = sum(k in 1..K) (ManpowerOne[k] + ManpowerTwo[k]);

% The strategy for each year must ensure that the production capacity for the year is not exceeded
constraint forall(k in 1..K) (sum(j in 1..K) (InputOne[k,j]*strategy[j] + InputTwo[k,j]*strategy[j]) <= Capacity[k]);

% The strategy for each year must ensure that the demand for the year is met
constraint forall(k in 1..K) (sum(j in 1..K) (InputOne[k,j]*strategy[j] + InputTwo[k,j]*strategy[j]) >= Demand[k]);

% The strategy for each year must ensure that the stock level at the beginning of the year is not exceeded
constraint forall(k in 1..K) (Stock[k] - sum(j in 1..K) (InputOne[k,j]*strategy[j] + InputTwo[k,j]*strategy[j]) >= 0);

% The strategy for each year must ensure that the stock level at the end of the year is not negative
constraint forall(k in 1..K) (Stock[k] + sum(j in 1..K) (InputOne[k,j]*strategy[j] + InputTwo[k,j]*strategy[j]) - Demand[k] >= 0);

% The strategy for each year must ensure that the increase in productive capacity in year t + 2 is not negative
constraint forall(k in 1..K) (if k+2 <= K then strategy[k] - Capacity[k+2] >= 0 else true endif);

% Objective
solve maximize total_manpower;