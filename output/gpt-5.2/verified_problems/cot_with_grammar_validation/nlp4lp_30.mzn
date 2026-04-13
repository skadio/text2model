int: K;
int: L;

array[1..K, 1..L] of int: Benefit;
array[1..K, 1..K] of float: Communication;
array[1..L, 1..L] of int: Cost;

array[1..K] of var 1..L: loc;

constraint
  forall(l in 1..L) (
    sum(k in 1..K)(bool2int(loc[k] = l)) <= 3
  );

var float: total_cost =
    sum(k in 1..K, j in 1..K)(
      Communication[k, j] * int2float(Cost[loc[k], loc[j]])
    )
  - int2float(sum(k in 1..K)(Benefit[k, loc[k]]));

solve minimize total_cost;