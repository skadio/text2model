int: K;
int: L;

array[1..K, 1..L] of float: Benefit;

set of int: DEPT = 1..K;
set of int: LOC  = 1..L;

array[DEPT, DEPT] of float: Communication;
array[LOC,  LOC]  of float: Cost;

array[DEPT] of var LOC: loc;

constraint
  forall(l in LOC)(
    sum(k in DEPT)(bool2int(loc[k] == l)) <= 3
  );

var float: total_benefit =
  sum(k in DEPT)(Benefit[k, loc[k]]);

var float: total_comm_cost =
  sum(k in DEPT, j in DEPT where k < j)(
    Communication[k, j] * Cost[loc[k], loc[j]]
  );

solve minimize total_comm_cost - total_benefit;