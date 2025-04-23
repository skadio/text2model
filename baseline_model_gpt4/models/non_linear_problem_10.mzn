include "globals.mzn";

% Parameters
int: ndepts; % Number of departments
int: ncities; % Number of cities
int: ncitiesm1; % Number of cities without the host city
array[1..ndepts, 1..ncities] of int: benefit; % Benefits for each department in each city
array[1..ncities, 1..ncities] of int: dist; % Communication costs between cities
array[1..ndepts, 1..ndepts] of int: comm; % Quantities of communication between departments

% Decision variables
array[1..ndepts] of var 1..ncities: dept_city; % City for each department

% Constraints
constraint forall(i in 1..ndepts)(count(dept_city, i) <= 3); % At most 3 departments in each city

% Objective function
var int: total_savings = sum(i in 1..ndepts, j in 1..ncities)(benefit[i,j] * (dept_city[i] = j)) - 
                          sum(i in 1..ndepts, j in 1..ndepts, k in 1..ncities, l in 1..ncities)
                          ((dept_city[i] = k) /\ (dept_city[j] = l) * dist[k,l] * comm[i,j]);
                          
% Maximize total savings
solve maximize total_savings;

% Output
output ["Department " ++ show(i) ++ " is in city " ++ show(dept_city[i]) ++ "\n" | i in 1..ndepts];