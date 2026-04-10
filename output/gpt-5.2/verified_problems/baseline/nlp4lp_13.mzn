int: N;
set of int: C = 1..N;

array[C] of float: Start;
array[C] of float: Limit;
array[C, C] of float: Rate;

array[C, C] of var float: X;  % amount exchanged from i to j (in units of currency i), nonnegative

% Total outgoing/incoming per currency must not exceed limits
constraint forall(i in C)(
  sum(j in C)(X[i,j]) <= Limit[i] /\
  sum(j in C)(Rate[j,i] * X[j,i]) <= Limit[i]
);

% Cannot exchange more than available (start + net inflow - outflow >= 0)
array[C] of var float: End;
constraint forall(i in C)(
  End[i] = Start[i] + sum(j in C)(Rate[j,i] * X[j,i]) - sum(j in C)(X[i,j]) /\
  End[i] >= 0.0
);

% No self-exchange
constraint forall(i in C)(X[i,i] = 0.0);

% Objective: maximize total units of currencies at end of day (sum of units)
solve maximize sum(i in C)(End[i]);

output [
  "End = [", concat([ if i>1 then ", " else "" endif ++ show(End[i]) | i in C ]), "]\n",
  "X = array2d(1..N,1..N,[", concat([ if idx>1 then ", " else "" endif ++ show(X[i,j])
                                      | idx in 1..(N*N), i = ((idx-1) div N)+1, j = ((idx-1) mod N)+1 ]), "])\n"
];