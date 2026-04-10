int: K;
int: L;

set of int: DEPTS = 1..K;
set of int: LOCS  = 1..L;

array[DEPTS, LOCS] of float: Benefit;
array[DEPTS, DEPTS] of float: Communication;
array[LOCS, LOCS] of float: Cost;

array[DEPTS] of var LOCS: DepartmentLocation;

constraint
  forall(l in LOCS) (
    sum(k in DEPTS)(bool2int(DepartmentLocation[k] == l)) <= 3
  );

var float: total_benefit =
  sum(k in DEPTS)(
    Benefit[k, DepartmentLocation[k]]
  );

var float: total_comm_cost =
  sum(k in DEPTS, j in DEPTS)(
    Communication[k, j] * Cost[DepartmentLocation[k], DepartmentLocation[j]]
  );

var float: total_cost = total_comm_cost - total_benefit;

solve minimize total_cost;

output [
  "DepartmentLocation = ", show(DepartmentLocation), "\n",
  "total_benefit = ", show(total_benefit), "\n",
  "total_comm_cost = ", show(total_comm_cost), "\n",
  "total_cost = ", show(total_cost), "\n"
];