% Parameters
int: ndepts; % Number of departments
int: ncities; % Number of cities
array[1..ndepts, 1..ncities] of int: benefit; % Benefits in £k for each department in each city
array[1..ncities, 1..ncities] of int: dist; % Communication costs per unit (£) between cities
array[1..ndepts, 1..ndepts] of int: comm; % Quantities of communication (k units) between departments

% Variables
array[1..ndepts] of var 1..ncities: dept_loc; % The city in which each department is located

% Constraints

% Each department must be located in one city
constraint forall(i in 1..ndepts)(exists(j in 1..ncities)(dept_loc[i] = j));

% There can be at most 3 departments in each city
constraint forall(j in 1..ncities)(sum(i in 1..ndepts)(bool2int(dept_loc[i] = j)) <= 3);

% Objective
solve maximize sum(i in 1..ndepts, j in 1..ncities)(benefit[i,j] * bool2int(dept_loc[i] = j)) - 
              sum(i in 1..ndepts, j in 1..ndepts, k in 1..ncities, l in 1..ncities)(
                  bool2int(dept_loc[i] = k) * bool2int(dept_loc[j] = l) * dist[k,l] * comm[i,j]
              );