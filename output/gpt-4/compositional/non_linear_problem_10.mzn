% Parameters
int: ndepts; % Number of departments
int: ncities; % Number of cities
int: ncitiesm1; % Number of cities without the host city
array[1..ndepts, 1..ncities] of int: benefit; % Benefits in £k for each department in each city
array[1..ncities, 1..ncities] of int: dist; % Communication costs per unit (£) between cities
array[1..ndepts, 1..ndepts] of int: comm; % Quantities of communication (k units) between departments

% Variables
array[1..ndepts] of var 1..ncities: dept_loc; % The city in which each department is located
array[1..ncities] of var 0..ndepts: city_depts; % The number of departments in each city

% Constraints

% Each department must be located in one city
constraint forall(i in 1..ndepts)(dept_loc[i] in 1..ncities);

% There can be at most 3 departments in each city
constraint forall(i in 1..ncities)(city_depts[i] <= 3);

% The number of departments in each city is equal to the sum of departments located in that city
constraint forall(i in 1..ncities)(city_depts[i] = sum(j in 1..ndepts)(if dept_loc[j] = i then 1 else 0 endif));

% Objective
solve maximize sum(i in 1..ndepts)(benefit[i, dept_loc[i]]) - sum(i in 1..ndepts, j in i+1..ndepts)(comm[i,j]*dist[dept_loc[i],dept_loc[j]]);