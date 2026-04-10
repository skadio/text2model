% Parameters
int: N;
set of int: C = 1..N;

array[C] of float: Start;
array[C] of float: Limit;
array[C, C] of float: Rate;

% Variables
array[C, C] of var float: x;          % amount of currency i exchanged into currency j (in units of i)
array[C] of var float: endAmt;        % end-of-day units of each currency

% Constraints
constraint forall(i in C, j in C) (x[i,j] >= 0.0);

% Per-currency total exchanged out of i is limited
constraint forall(i in C) (
  sum(j in C)(x[i,j]) <= Limit[i]
);

% Per-currency total exchanged into i (measured in units of i) is limited:
% incoming to i from j produces Rate[j,i] * x[j,i] units of i
constraint forall(i in C) (
  sum(j in C)(Rate[j,i] * x[j,i]) <= Limit[i]
);

% Flow balance: end amount = start - outgoing + incoming (converted)
constraint forall(i in C) (
  endAmt[i] = Start[i] - sum(j in C)(x[i,j]) + sum(j in C)(Rate[j,i] * x[j,i])
);

% Cannot end with negative holdings
constraint forall(i in C) (endAmt[i] >= 0.0);

% Objective
solve maximize sum(i in C)(endAmt[i]);