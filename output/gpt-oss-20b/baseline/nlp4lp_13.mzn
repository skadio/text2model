int: N;
array[1..N] of float: Start;
array[1..N] of float: Limit;
array[1..N, 1..N] of float: Rate;

array[1..N, 1..N] of var float: x;
array[1..N] of var float: final;

constraint
  % No self‑exchange
  forall(i in 1..N) (
    x[i,i] = 0
  )
  /\ % Exchange limits
  forall(i in 1..N) (
    sum(j in 1..N) x[i,j] + sum(j in 1..N) x[j,i] <= Limit[i]
  )
  /\ % Non‑negative flows
  forall(i in 1..N, j in 1..N) (
    x[i,j] >= 0
  )
  /\ % Final balances
  forall(i in 1..N) (
    final[i] = Start[i]
               - sum(j in 1..N) x[i,j]
               + sum(j in 1..N) x[j,i] * Rate[j,i]
  )
  /\ % Final balances must be non‑negative
  forall(i in 1..N) (
    final[i] >= 0
  );

solve maximize final[1];

output [
  "Maximum amount of currency 1 at end of day: ", show(final[1]), "\n",
  "Final balances: ", show(final), "\n"
];