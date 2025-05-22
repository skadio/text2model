% Parameters
int: K; % Number of departments
int: L; % Number of possible locations
array[1..K, 1..L] of int: Benefit; % Benefit of department k being located at location l
array[1..K, 1..K] of float: Communication; % Communication costs between departments k and j
array[1..L, 1..L] of int: Cost; % Cost of locating at location l with requirement m

% Variables
array[1..K] of var 1..L: location; % Location of each department

% Constraints
constraint forall(l in 1..L)(sum(k in 1..K)(bool2int(location[k] = l)) <= 3); % No more than three departments in the same location
constraint forall(k in 1..K, j in 1..K)(location[k] != location[j] -> Communication[k, j] * Cost[location[k], location[j]] >= 0.0); % Communication cost is non-negative

% Objective
var float: total_cost = sum(k in 1..K)(Benefit[k, location[k]]) - sum(k in 1..K, j in 1..K)(Communication[k, j] * Cost[location[k], location[j]]);
solve minimize total_cost;