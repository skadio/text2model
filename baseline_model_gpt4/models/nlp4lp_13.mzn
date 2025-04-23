include "globals.mzn";

% Number of different currencies
int: N;

% Initial amount of currency i
array[1..N] of float: Start;

% Limit for the number of transactions for currency i
array[1..N] of float: Limit;

% Exchange rate from currency i to currency j
array[1..N, 1..N] of float: Rate;

% Decision variable: number of transactions from currency i to currency j
array[1..N, 1..N] of var 0.0..Limit[i]: Transactions;

% Objective: maximize the number of units of currency that we end up with at the end of the day
var float: total_currency = sum(i in 1..N) (Start[i] + sum(j in 1..N) (Transactions[j, i] * Rate[j, i]) - sum(j in 1..N) (Transactions[i, j]));

% Constraint: the total amount of each currency that can be exchanged should not exceed the limit
constraint forall(i in 1..N) (sum(j in 1..N) (Transactions[i, j] + Transactions[j, i]) <= Limit[i]);

% Constraint: wealth cannot be multiplied by going through a cycle of currencies
constraint forall(i in 1..N, j in 1..N) (Transactions[i, j] * Rate[i, j] <= Transactions[j, i]);

% Solve
solve maximize total_currency;

% Output
output ["Total currency: ", show(total_currency), "\nTransactions: "] ++ [if fix(Transactions[i, j]) > 0 then "From currency " ++ show(i) ++ " to currency " ++ show(j) ++ ": " ++ show(Transactions[i, j]) ++ "\n" else "" endif | i in 1..N, j in 1..N];