int: Period;
array[1..7] of int: Demand;

int: maxDemand = max([Demand[d] | d in 1..7]);
int: UB = 7 * maxDemand;

array[1..7, 1..Period] of var 0..UB: start;
var 0..UB: N;

constraint N = sum(d in 1..7, x in 1..Period)(start[d, x]);

constraint
  forall(w in 1..7) (
    sum(d in 1..7, x in 1..Period where (((w - d + 7) mod 7) < x))(start[d, x]) >= Demand[w]
  );

solve minimize N;