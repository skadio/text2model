% Parameters
int: K; % Number of departments
int: L; % Number of possible locations
array[1..K, 1..L] of int: Benefit; % Benefit of department k being located at location l
array[1..K, 1..K] of int: Communication; % Communication costs between departments k and j
array[1..L, 1..L] of int: Cost; % Cost of locating at location l with requirement m

% Variables
array[1..K] of var 1..L: location; % Location of each department

% Constraints

% Constraint 1: None of the cities (including London) may be the location for more than three of the departments.
constraint forall(l in 1..L) (
  sum(k in 1..K)(bool2int(location[k] = l)) <= 3
);

% Objective
solve minimize sum(k in 1..K, l in 1..L)(if location[k] = l then -Benefit[k, l] else 0 endif) + 
               sum(k in 1..K, j in 1..K, l in 1..L, m in 1..L)(if location[k] = l /\ location[j] = m then Communication[k, j] * Cost[l, m] else 0 endif);