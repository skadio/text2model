include "globals.mzn";

% Parameters
int: N; % Number of different currencies
array[1..N] of float: Start; % Initial amount of currency i
array[1..N] of float: Limit; % Limit for the number of transactions for currency i
array[1..N, 1..N] of float: Rate; % Exchange rate from currency i to currency j

% Variables
array[1..N, 1..N] of var 0.0..Limit[i]: Transactions; % Number of transactions from currency i to j
array[1..N] of var 0.0..sum(j in 1..N)(Limit[j]): End; % Final amount of currency i

% Constraints
constraint forall(i in 1..N)(End[i] = Start[i] + sum(j in 1..N)(Transactions[j, i]*Rate[j, i]) - sum(j in 1..N)(Transactions[i, j]));
constraint forall(i in 1..N)(sum(j in 1..N)(Transactions[i, j]) <= Limit[i]);
constraint forall(i in 1..N, j in 1..N)(Transactions[i, j] >= 0);

% Objective
var float: total = sum(i in 1..N)(End[i]);
solve maximize total;

% Output
output ["Total: ", show(total), "\n"] ++ ["End: ", show(End), "\n"] ++ ["Transactions: ", show(Transactions), "\n"];