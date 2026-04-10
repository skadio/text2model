int: ndepts;
int: ncities;
int: ncitiesm1;

array[1..ndepts, 1..ncities] of int: benefit;   % £k
array[1..ncities, 1..ncities] of int: dist;     % £ per unit
array[1..ndepts, 1..ndepts] of int: comm;       % k units

set of int: DEPTS = 1..ndepts;
set of int: CITIES = 1..ncities;

array[DEPTS] of var CITIES: loc;

constraint
  forall(c in CITIES) (
    sum(d in DEPTS)(bool2int(loc[d] == c)) <= 3
  );

% Objective:
% total savings = sum of department benefits (in £k)
%                - sum of communication costs between department pairs
% Communication cost uses comm in k units and dist in £ per unit => £k.
var int: total_benefit = sum(d in DEPTS)(benefit[d, loc[d]]);

var int: total_comm_cost =
  sum(d1 in DEPTS, d2 in DEPTS where d1 < d2)(
    comm[d1, d2] * dist[loc[d1], loc[d2]]
  );

var int: total_savings = total_benefit - total_comm_cost;

solve maximize total_savings;

output [
  "total_savings(£k)=", show(total_savings), "\n",
  "total_benefit(£k)=", show(total_benefit), "\n",
  "total_comm_cost(£k)=", show(total_comm_cost), "\n",
  "loc=", show(loc), "\n"
];