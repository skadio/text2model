% Parameters
int: N;
array[1..N] of float: Start;
array[1..N] of float: Limit;
array[1..N, 1..N] of float: Rate;

% Variables
array[1..N, 1..N] of var float: Transactions;

% Constraints
constraint forall(i in 1..N)(
  sum(j in 1..N)(Transactions[i,j]) <= Limit[i]
);

constraint forall(i in 1..N)(
  sum(j in 1..N)(Transactions[j,i]) <= Limit[i]
);

constraint forall(i in 1..N, j in 1..N)(
  Transactions[i,j] * Rate[i,j] <= Transactions[j,i]
);

% Objective
var float: total_currency = sum(i in 1..N)(Start[i] + sum(j in 1..N)(Transactions[j,i] * Rate[j,i]) - sum(k in 1..N)(Transactions[i,k]));

solve maximize total_currency;