% Parameters
int: K; % Number of departments
int: L; % Number of possible locations
array[1..K, 1..L] of int: Benefit; % Benefit of department k being located at location l
array[1..K, 1..K] of float: Communication; % Communication costs between departments k and j
array[1..L, 1..L] of int: Cost; % Cost of locating at location l with requirement m

% Variables
array[1..K] of var 1..L: location; % Location of each department

% Constraints
% Each location can have at most 3 departments
constraint forall(l in 1..L) (
  sum(k in 1..K)(bool2int(location[k] = l)) <= 3
);

% Objective
% Minimize the overall yearly cost
var int: total_cost;
constraint total_cost = sum(k in 1..K)(Benefit[k, location[k]]) - sum(k in 1..K, j in 1..K where k != j, l in 1..L, m in 1..L) (Communication[k, j] * Cost[l, m] * bool2int(location[k] = l and location[j] = m));
solve minimize total_cost;