% Parameters
int: ndepts; % Number of departments
int: ncities; % Number of cities
int: ncitiesm1; % Number of cities without the host city
array[1..ndepts, 1..ncities] of int: benefit; % Benefits in £k for each department in each city
array[1..ncities, 1..ncities] of int: dist; % Communication costs per unit (£) between cities
array[1..ndepts, 1..ndepts] of int: comm; % Quantities of communication (k units) between departments

% Variables
array[1..ndepts] of var 1..ncities: dept_loc; % Location of each department

% Constraints
constraint forall(i in 1..ncities)(count(dept_loc, i) <= 3); % There can be at most 3 departments in each city

% Objective
var int: total_savings = sum(i in 1..ndepts, j in 1..ncities)(benefit[i,j] * (dept_loc[i] = j)) - sum(i in 1..ncities, j in 1..ncities)(dist[i,j] * sum(k in 1..ndepts)(dept_loc[k] = i) * sum(l in 1..ndepts)(dept_loc[l] = j) * comm[k,l]);
solve maximize total_savings;