% Currency exchange optimization with per-currency total-exchanged limits.
% Data provided in .dzn:
%   int: N;
%   array[1..N] of float: Start;
%   array[1..N] of float: Limit;
%   array[1..N,1..N] of float: Rate;

int: N;
set of int: C = 1..N;

array[C] of float: Start;
array[C] of float: Limit;
array[C,C] of float: Rate;

% Decision variables:
% x[i,j] = amount (in currency i units) exchanged from i to j during the day.
array[C,C] of var float: x;

% End holdings of each currency after all exchanges:
array[C] of var float: End;

% --- Constraints ---

% Nonnegativity; and disallow self-exchange to avoid pointless cycling.
constraint forall(i in C, j in C) (
  x[i,j] >= 0.0 /\
  (if i == j then x[i,j] = 0.0 else true endif)
);

% Per-currency total amount exchanged (outgoing + incoming, both measured in that currency)
% may not exceed Limit[i].
% Incoming to i from k is x[k,i]*Rate[k,i] units of currency i.
constraint forall(i in C) (
  sum(j in C)(x[i,j]) + sum(k in C)(x[k,i] * Rate[k,i]) <= Limit[i]
);

% Cannot exchange out more of a currency than you have at the start plus what you receive.
% (This avoids needing a time-expanded model; since there is no profitable cycle, netting is safe.)
constraint forall(i in C) (
  sum(j in C)(x[i,j]) <= Start[i] + sum(k in C)(x[k,i] * Rate[k,i])
);

% Flow balance to compute end-of-day holdings:
constraint forall(i in C) (
  End[i] = Start[i]
           - sum(j in C)(x[i,j])
           + sum(k in C)(x[k,i] * Rate[k,i])
);

% Keep holdings nonnegative.
constraint forall(i in C)(End[i] >= 0.0);

% Objective: maximize total units held across all currencies at end of day.
solve maximize sum(i in C)(End[i]);

output [
  "x (exchanged amounts in source currency units):\n",
  concat([ concat([ if j==1 then "" else " " endif ++ show(x[i,j]) | j in C ]) ++ "\n" | i in C ]),
  "End:\n", show(End), "\n",
  "TotalEnd = ", show(sum(i in C)(End[i])), "\n"
];