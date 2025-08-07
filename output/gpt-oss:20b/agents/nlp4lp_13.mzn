include "globals.mzn";

int: N;
array[1..N] of float: Start;
array[1..N] of float: Limit;
array[1..N, 1..N] of float: Rate;

/* Variables --------------------------------------------------------*/
array[1..N, 1..N] of var 0.0..max(Limit): x;   % amount of currency i exchanged to j
array[1..N] of var float: final;               % amount of each currency at the end

/* Constraints ------------------------------------------------------*/
% 1.  total amount of each currency that can be exchanged
constraint forall(i in 1..N)(
    sum(j in 1..N) (x[i][j]) + sum(k in 1..N) (x[k][i] * Rate[k][i]) <= Limit[i]
);

% 2.  flow conservation for every currency
constraint forall(i in 1..N)(
    Start[i] + sum(k in 1..N) (x[k][i] * Rate[k][i]) 
    == final[i] + sum(j in 1..N) (x[i][j])
);

% 3.  no self‑exchange
constraint forall(i in 1..N) (x[i][i] = 0);

% 4.  final amounts must be non‑negative
constraint forall(i in 1..N) (final[i] >= 0);

/* Objective -------------------------------------------------------*/
% maximise the amount of currency 1 at the end of the day
solve maximize final[1];

/* Output ----------------------------------------------------------*/
output [
  "Final amounts: ", show(final), "\n",
  "Maximum amount of currency 1: ", show(final[1]), "\n"
];