include "globals.mzn";

int: K;  % Number of departments
int: L;  % Number of possible locations

array[1..K] of var 1..L: location;  % Location for each department

array[1..L] of int: max_counts = [3, 3, 3];  % Max departments per location
array[1..L] of var 0..K: counts;  % Counts of departments at each location

% Constraints to ensure no more than 3 departments in any location
constraint global_cardinality(location, 1..L, counts);
constraint forall(i in 1..L)(counts[i] <= max_counts[i]);

% Objective function: Minimize the total cost
array[1..K, 1..L] of int: Benefit;  % Benefit of department k being located at location l
array[1..K, 1..K] of float: Communication;  % Communication costs between departments k and j
array[1..L, 1..L] of int: Cost;  % Cost of locating at location l with requirement m

% Calculate total cost
var int: total_cost = sum(k in 1..K)(
    sum(l in 1..L)( 
        (Cost[location[k], location[k]] * Communication[k, k]) - Benefit[k, location[k]]
    )
);

% Solve the model
solve minimize total_cost;

% Output the results
output [ "Location = ", show(location), "\nTotal Cost = ", show(total_cost), "\n" ];