include "globals.mzn";

% -------------------- Data ---------------------------------
int: ndepts;                       % number of departments
int: ncities;                      % number of cities
int: ncitiesm1;                    % number of cities excluding the host (unused in model)

array[1..ndepts, 1..ncities] of int: benefit;   % benefit[dept, city]
array[1..ncities, 1..ncities] of int: dist;     % communication cost per unit between cities
array[1..ndepts, 1..ndepts] of int: comm;      % quantity of communication between departments

% -------------------- Decision variables ------------------
array[1..ndepts] of var 1..ncities: city;      % city chosen for each department

% -------------------- Cardinality constraints ------------
array[1..ncities] of int: lo = [0 | c in 1..ncities];
array[1..ncities] of int: up = [3 | c in 1..ncities];
constraint global_cardinality_low_up(city, lo, up);

% -------------------- Objective --------------------------
var int: totalBenefit = sum(dept in 1..ndepts)(
                          benefit[dept, city[dept]] );

var int: totalCommCost = sum(i in 1..ndepts)(
                           sum(j in i+1..ndepts)(
                               comm[i, j] * dist[city[i], city[j]] ) );

var int: totalSavings = totalBenefit - totalCommCost;

solve maximize totalSavings;

output [
  "Total Benefit: ", show(totalBenefit), "\n",
  "Total Communication Cost: ", show(totalCommCost), "\n",
  "Total Savings: ", show(totalSavings), "\n",
  "Locations: ", show(city), "\n"
];