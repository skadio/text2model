% Parameters
int: ndepts; % Number of departments
int: ncities; % Number of cities
int: ncitiesm1; % Number of cities without the host city
array[1..ndepts, 1..ncities] of int: benefit; % Benefits in £k for each department in each city
array[1..ncities, 1..ncities] of int: dist; % Communication costs per unit (£) between cities
array[1..ndepts, 1..ndepts] of int: comm; % Quantities of communication (k units) between departments

% Variables
array[1..ndepts] of var 1..ncities: dept_city; % City in which each department is located

% Constraints
constraint forall(i in 1..ncities)(count(dept_city, i) <= 3); % At most 3 departments in each city

constraint forall(i in 1..ndepts, j in 1..ndepts)(
  if i != j then
    dist[dept_city[i], dept_city[j]] * comm[i, j] <= benefit[i, dept_city[i]]
  endif
); % Communication cost between departments in different cities should not exceed the benefit of the department in its city

% Objective
var int: total_savings = sum(i in 1..ndepts)(benefit[i, dept_city[i]]) - sum(i in 1..ndepts, j in 1..ndepts)(dist[dept_city[i], dept_city[j]] * comm[i, j]);
solve maximize total_savings;