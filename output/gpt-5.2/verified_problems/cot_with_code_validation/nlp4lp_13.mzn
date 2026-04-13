% Currency exchange optimization model
% Parameters
int: N;
set of int: C = 1..N;

array[C] of float: Start;
array[C] of float: Limit;
array[C, C] of float: Rate;

% Variables
array[C, C] of var float: x;        % amount of currency i exchanged into currency j (in units of i)
array[C] of var float: endAmt;      % end-of-day holdings of each currency
var float: totalEnd;

% Constraints

% Nonnegativity of exchanges
constraint forall(i in C, j in C) ( x[i,j] >= 0.0 );

% Do not exchange a currency into itself
constraint forall(i in C) ( x[i,i] = 0.0 );

% No borrowing: outgoing from currency i cannot exceed starting amount
constraint forall(i in C) ( sum(j in C)(x[i,j]) <= Start[i] );

% Regulation limit: total amount of currency i exchanged out plus exchanged in (measured in currency i)
constraint forall(i in C) (
  sum(j in C)(x[i,j]) + sum(j in C)(Rate[j,i] * x[j,i]) <= Limit[i]
);

% End-of-day balance for each currency
constraint forall(i in C) (
  endAmt[i] = Start[i]
            - sum(j in C)(x[i,j])
            + sum(j in C)(Rate[j,i] * x[j,i])
);

% Final holdings must be nonnegative
constraint forall(i in C) ( endAmt[i] >= 0.0 );

% Total end-of-day holdings (sum across currencies, as specified)
constraint totalEnd = sum(i in C)(endAmt[i]);

% Objective
solve maximize totalEnd;