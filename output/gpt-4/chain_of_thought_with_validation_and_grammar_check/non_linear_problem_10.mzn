% Parameters
int: ndepts; % Number of departments
int: ncities; % Number of cities
array[1..ndepts, 1..ncities] of int: benefit; % Benefits in £k for each department in each city
array[1..ncities, 1..ncities] of int: dist; % Communication costs per unit (£) between cities
array[1..ndepts, 1..ndepts] of int: comm; % Quantities of communication (k units) between departments

% Variables
array[1..ndepts] of var 1..ncities: location; % Location of each department

% Constraints
constraint forall(i in 1..ncities)(count(location, i) <= 3); % At most 3 departments in each city
constraint forall(i in 1..ndepts)(location[i] in 1..ncities); % Each department must be located in one city

% Objective
var int: total_savings = sum(i in 1..ndepts, j in 1..ncities)(benefit[i,j] * (location[i] = j)) - 
                         sum(i in 1..ndepts, j in i+1..ndepts)(dist[location[i],location[j]] * comm[i,j]);
                         
solve maximize total_savings;