% Parameters
int: ndepts;
int: ncities;
int: ncitiesm1;

array[1..ndepts, 1..ncities] of int: benefit;
array[1..ncities, 1..ncities] of int: dist;
array[1..ndepts, 1..ndepts] of int: comm;

% Variables
array[1..ndepts] of var 1..ncities: loc;

% Constraints
constraint
  forall(c in 1..ncities) (
    sum(d in 1..ndepts)(bool2int(loc[d] = c)) <= 3
  );

% Objective
var int: total_benefit =
  sum(d in 1..ndepts)( benefit[d, loc[d]] );

var int: total_comm_cost =
  sum(d1 in 1..ndepts, d2 in d1+1..ndepts)(
    comm[d1,d2] * dist[loc[d1], loc[d2]]
  );

var int: total_savings = total_benefit - total_comm_cost;

solve maximize total_savings;