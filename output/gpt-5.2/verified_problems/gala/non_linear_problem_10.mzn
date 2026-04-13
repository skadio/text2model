include "globals.mzn";

%-------------------------
% Input data
%-------------------------
int: ndepts;
int: ncities;
int: ncitiesm1; % not needed for the model, but may be present in data

array[1..ndepts, 1..ncities] of int: benefit;   % £k
array[1..ncities, 1..ncities] of int: dist;     % £ per unit
array[1..ndepts, 1..ndepts] of int: comm;       % k units

%-------------------------
% Decision variables
%-------------------------
array[1..ndepts] of var 1..ncities: city_of_dept;

% At most 3 departments per city (use GCC low/up as hinted)
array[1..ncities] of int: values = [c | c in 1..ncities];
array[1..ncities] of int: lo = [0 | c in 1..ncities];
array[1..ncities] of int: up = [3 | c in 1..ncities];
constraint global_cardinality_low_up(city_of_dept, values, lo, up);

%-------------------------
% Objective: maximize total savings
% savings = sum of benefits - communication costs
% Communication cost between dept i and j is comm[i,j] * dist[city(i), city(j)]
%-------------------------
var int: total_benefit =
  sum(d in 1..ndepts)( benefit[d, city_of_dept[d]] );

var int: total_comm_cost =
  sum(i in 1..ndepts, j in 1..ndepts)(
    comm[i,j] * dist[ city_of_dept[i], city_of_dept[j] ]
  );

var int: total_savings = total_benefit - total_comm_cost;

solve maximize total_savings;

output [
  "city_of_dept = ", show(city_of_dept), "\n",
  "total_benefit = ", show(total_benefit), "\n",
  "total_comm_cost = ", show(total_comm_cost), "\n",
  "total_savings = ", show(total_savings), "\n"
];