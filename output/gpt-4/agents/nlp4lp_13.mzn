% Parameters
int: N; % Number of different currencies
array[1..N] of float: Start; % Initial amount of each currency
array[1..N] of float: Limit; % Limit for the number of transactions for each currency
array[1..N, 1..N] of float: Rate; % Exchange rate from currency i to currency j

% Variables
array[1..N] of var 0.0..float: End; % Amount of each currency at the end of the day
array[1..N, 1..N] of var 0.0..float: Transactions; % Number of transactions from currency i to currency j

% Constraints

% The amount of each currency at the end of the day is the initial amount plus the sum of all incoming transactions minus the sum of all outgoing transactions
constraint forall(i in 1..N) (
    End[i] = Start[i] + sum(j in 1..N) (Transactions[j, i] * Rate[j, i]) - sum(j in 1..N) (Transactions[i, j])
);

% The total number of transactions for each currency cannot exceed the limit
constraint forall(i in 1..N) (
    sum(j in 1..N) (Transactions[i, j] + Transactions[j, i]) <= Limit[i]
);

% The number of transactions from currency i to currency j cannot be negative
constraint forall(i in 1..N, j in 1..N) (
    Transactions[i, j] >= 0
);

% The wealth cannot be multiplied by going through a cycle of currencies
constraint forall(i in 1..N, j in 1..N) (
    Transactions[i, j] * Rate[i, j] <= Transactions[j, i]
);

% Objective
solve maximize sum(i in 1..N) (End[i]);