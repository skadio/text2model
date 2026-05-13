% Parameters
int: N;
array[1..N] of float: Start;
array[1..N] of float: Limit;
array[1..N, 1..N] of float: Rate;

% Variables
array[1..N, 1..N] of var float: x;          % amount exchanged from i to j
array[1..N] of var float: Final;            % final amount of each currency

% Constraints
constraint
  % No self‑exchange
  forall(i in 1..N) (x[i,i] = 0.0) /\
  % Non‑negative exchanges
  forall(i in 1..N, j in 1..N) (x[i,j] >= 0.0) /\
  % Exchange limits for each currency
  forall(i in 1..N) (
    sum(j in 1..N)(x[i,j]) + sum(k in 1..N)(x[k,i]) <= Limit[i]
  ) /\
  % Availability of currency i for sending
  forall(i in 1..N) (
    sum(j in 1..N)(x[i,j]) <= Start[i] + sum(k in 1..N)(x[k,i])
  ) /\
  % Final amounts
  forall(i in 1..N) (
    Final[i] = Start[i] + sum(k in 1..N)(x[k,i]) - sum(j in 1..N)(x[i,j])
  ) /\
  % Non‑negative final amounts
  forall(i in 1..N) (Final[i] >= 0.0);

% Objective
solve maximize Final[1];