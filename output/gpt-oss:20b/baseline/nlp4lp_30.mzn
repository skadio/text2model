int: K;
int: L;
array[1..K, 1..L] of float: Benefit;
array[1..K, 1..K] of float: Communication;
array[1..L, 1..L] of float: Cost;

array[1..K] of var 1..L: loc;

constraint
  forall(l in 1..L) (
    sum(k in 1..K) (bool2int(loc[k] == l)) <= 3
  );

var float: total_cost = sum(k in 1..K) (-Benefit[k, loc[k]]) 
                       + sum(k in 1..K, j in 1..K) Communication[k,j] * Cost[loc[k], loc[j]];

solve minimize total_cost;

output [
  "Location assignments:\n",
  concat([ "Department " ++ show(k) ++ ": " ++ show(loc[k]) ++ "\n" | k in 1..K]),
  "\nTotal cost: " ++ show(total_cost) ++ "\n"
];