include "globals.mzn";

% Parameters
int: K; % Number of departments
int: L; % Number of possible locations
array[1..K, 1..L] of int: Benefit; % Benefit of department k being located at location l
array[1..K, 1..K] of float: Communication; % Communication costs between departments k and j
array[1..L, 1..L] of int: Cost; % Cost of locating at location l with requirement m

% Variables
array[1..K] of var 1..L: location; % Location of each department

% Constraints
constraint forall(l in 1..L)(sum(k in 1..K)(bool2int(location[k] = l)) <= 3); % No more than 3 departments per location

% Objective
var float: total_cost;
constraint total_cost = sum(k in 1..K, l in 1..L)(Benefit[k, l] * bool2int(location[k] = l)) - sum(k in 1..K, j in 1..K, l in 1..L, m in 1..L)(Communication[k, j] * Cost[l, m] * bool2int(location[k] = l) * bool2int(location[j] = m));
solve minimize total_cost;

% Output
output ["Total cost: ", show(total_cost), "\n"] ++ ["Department ", show(k), " is located in city ", show(location[k]), "\n" | k in 1..K];