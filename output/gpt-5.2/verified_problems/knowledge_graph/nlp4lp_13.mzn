int: N;
set of int: C = 1..N;

array[C] of float: Start;
array[C] of float: Limit;
array[C, C] of float: Rate;

% Decision variables:
% x[i,j] = amount of currency i exchanged into currency j (in units of currency i)
array[C, C] of var float: x;

% Total outflow/inflow per currency
array[C] of var float: outflow = [sum(j in C)(x[i,j]) | i in C];
array[C] of var float: inflow  = [sum(j in C)(x[j,i] * Rate[j,i]) | i in C];

% End-of-day holdings
array[C] of var float: End = [Start[i] - outflow[i] + inflow[i] | i in C];

% Basic bounds (no negative exchanges, no self-exchange)
constraint forall(i,j in C)(x[i,j] >= 0.0);
constraint forall(i in C)(x[i,i] = 0.0);

% Cannot exchange more than you have initially (single-day, no intermediate borrowing)
constraint forall(i in C)(outflow[i] <= Start[i]);

% Regulation: limit total amount of each currency exchanged (outgoing)
constraint forall(i in C)(outflow[i] <= Limit[i]);

% Ensure nonnegative end-of-day holdings
constraint forall(i in C)(End[i] >= 0.0);

% Objective: maximize total end-of-day units (sum across currencies)
var float: TotalEnd = sum(i in C)(End[i]);
solve maximize TotalEnd;

output [
  "TotalEnd=", show(TotalEnd), "\n",
  "End=", show(End), "\n",
  "x=\n", show(x), "\n"
];