include "globals.mzn";

int: ndepts;                          % Number of departments
int: ncities;                         % Number of cities
int: ncitiesm1;                       % Number of cities without the host city
array[1..ndepts, 1..ncities] of int: benefit;  % Benefits for each department in each city
array[1..ncities, 1..ncities] of int: dist;     % Communication costs between cities
array[1..ndepts, 1..ndepts] of int: comm;       % Quantities of communication between departments

/* Variables */
array[1..ndepts] of var 1..ncities: location;  % Location of each department

/* Constraints */
% Each department must be located in one city
% At most 3 departments can be in each city
array[1..ncities] of var 0..3: city_count;      % Count of departments in each city
constraint global_cardinality(location, 1..ncities, city_count);

/* Objective function */
var int: total_benefit = sum(i in 1..ndepts)(benefit[i, location[i]]);
var int: total_cost = sum(i in 1..ndepts)(sum(j in 1..ndepts)(comm[i,j] * dist[location[i], location[j]]));
var int: total_savings = total_benefit - total_cost;

/* Solve */
solve maximize total_savings;

/* Output */
output [ "Location = ", show(location), "\nTotal Savings = ", show(total_savings), "\n" ];