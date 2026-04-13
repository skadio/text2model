int: ndepts;
int: ncities;
int: ncitiesm1;

array[1..ndepts, 1..ncities] of int: benefit;
array[1..ncities, 1..ncities] of float: dist;
array[1..ndepts, 1..ndepts] of int: comm;

array[1..ndepts] of var 1..ncities: loc;

constraint
  forall(c in 1..ncities) (
    sum(d in 1..ndepts)(bool2int(loc[d] = c)) <= 3
  );

var int: total_benefit =
  sum(d in 1..ndepts)(benefit[d, loc[d]]);

var float: total_comm_cost =
  sum(d1 in 1..ndepts, d2 in 1..ndepts where d1 != d2)(
    int2float(comm[d1, d2]) * dist[loc[d1], loc[d2]]
  );

solve maximize int2float(total_benefit) - total_comm_cost;