% Parameters
int: N;
array[1..N] of float: Start;
array[1..N] of float: Limit;
array[1..N, 1..N] of float: Rate;

% Variables
array[1..N, 1..N] of var float: x;      % amount of currency i converted to currency j
array[1..N] of var float: End;          % final amount of currency i after all exchanges

% Constraints
constraint
    forall(i in 1..N, j in 1..N) (
        x[i,j] >= 0.0
    );

constraint
    forall(i in 1..N) (
        x[i,i] = 0.0                    % no self-exchange
    );

constraint
    forall(i in 1..N) (
        sum(j in 1..N)(x[i,j]) <= Start[i]   % cannot exchange more than the initial amount
    );

constraint
    forall(i in 1..N) (
        End[i] = Start[i]
                 - sum(j in 1..N)(x[i,j])
                 + sum(j in 1..N)(x[j,i] * Rate[j,i])
    );

constraint
    forall(i in 1..N) (
        sum(j in 1..N)(x[i,j]) + sum(j in 1..N)(x[j,i] * Rate[j,i]) <= Limit[i]
    );

% Objective
solve maximize sum(i in 1..N)(End[i]);