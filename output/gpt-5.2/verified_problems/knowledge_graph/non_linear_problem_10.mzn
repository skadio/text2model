int: ndepts;
int: ncities;
int: ncitiesm1;

set of int: DEPTS = 1..ndepts;
set of int: CITIES = 1..ncities;

array[DEPTS, CITIES] of float: benefit;  % £k
array[CITIES, CITIES] of float: dist;    % £ per unit
array[DEPTS, DEPTS] of float: comm;      % k units

% Decision: location of each department
array[DEPTS] of var CITIES: loc;

% Capacity: at most 3 departments per city
constraint
  forall(c in CITIES) (
    sum(d in DEPTS) (bool2int(loc[d] == c)) <= 3
  );

% Objective: maximize total savings = total benefit - communication costs
% Communication cost between departments i,j is comm[i,j] (k units) * dist[city_i, city_j] (£ per unit)
% => £k when multiplied, so it is consistent with benefit in £k.
var float: total_benefit =
  sum(d in DEPTS, c in CITIES) (benefit[d,c] * bool2int(loc[d] == c));

var float: total_comm_cost =
  sum(i in DEPTS, j in DEPTS) (comm[i,j] * dist[loc[i], loc[j]]);

var float: total_savings = total_benefit - total_comm_cost;

solve maximize total_savings;

output [
  "total_savings=", show(total_savings), "\n",
  "total_benefit=", show(total_benefit), "\n",
  "total_comm_cost=", show(total_comm_cost), "\n",
  "loc=", show(loc), "\n"
];