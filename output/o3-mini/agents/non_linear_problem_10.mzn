include "globals.mzn";

% Input data (provided via a .dzn file)
int: ndepts;         % Number of departments
int: ncities;        % Total number of cities (including the host city)
int: ncitiesm1;      % Number of candidate cities excluding the host city

array[1..ndepts, 1..ncities] of int: benefit;   % Benefit (in £k) for each department in each city
array[1..ncities, 1..ncities] of int: dist;       % Communication cost per unit between cities
array[1..ndepts, 1..ndepts] of int: comm;         % Communication quantity (k units) between departments

% Decision variables:
% deptCity[i] represents the city assigned to department i.
array[1..ndepts] of var 1..ncities: deptCity;

% Capacity constraint: At most 3 departments can be located in any city.
array[1..ncities] of int: lo = [0 | i in 1..ncities];
array[1..ncities] of int: up = [3 | i in 1..ncities];
constraint global_cardinality_low_up(deptCity, 1..ncities, lo, up);

% Objective:
% Total savings = Sum of benefits for the chosen city for each department 
%                minus the sum of communication costs between every pair of departments.
% Communication cost for a pair of departments is computed as:
%   comm[i,j] * dist[deptCity[i], deptCity[j]]
var int: totalSavings = sum(i in 1..ndepts)( benefit[i, deptCity[i]] )
                      - sum(i in 1..ndepts, j in i+1..ndepts)( comm[i,j] * dist[deptCity[i], deptCity[j]] );

solve maximize totalSavings;

output [
  "Department Assignments (by city): ", show(deptCity), "\n",
  "Total Savings: ", show(totalSavings), "\n"
];