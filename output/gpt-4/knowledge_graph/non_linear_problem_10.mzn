include "globals.mzn";

% Parameters
int: ndepts; % Number of departments
int: ncities; % Number of cities
int: ncitiesm1; % Number of cities without the host city
array[1..ndepts, 1..ncities] of int: benefit; % Benefits in £k for each department in each city
array[1..ncities, 1..ncities] of int: dist; % Communication costs per unit (£) between cities
array[1..ndepts, 1..ndepts] of int: comm; % Quantities of communication (k units) between departments

% Variables
array[1..ndepts] of var 1..ncities: location; % Location of each department

% Constraints
constraint forall(i in 1..ndepts)(count(location, i) <= 3); % At most 3 departments in each city

% Objective
var int: total_savings;
constraint total_savings = sum(i in 1..ndepts, j in 1..ncities)(benefit[i,j] * (location[i] = j)) - sum(i in 1..ndepts, j in 1..ndepts, k in 1..ncities, l in 1..ncities)(comm[i,j] * dist[k,l] * (location[i] = k) * (location[j] = l));
solve maximize total_savings;

% Output
output ["Total savings: ", show(total_savings), "\n"] ++ ["Department ", show(i), " is located in city ", show(location[i]), "\n" | i in 1..ndepts];