% Gambling allocation problem (linear)
% Data embedded in model

int: BUDGET = 100000;

set of int: BETS = 1..3;
array[BETS] of float: lose_prob = [0.50, 0.25, 0.10];
array[BETS] of float: payout_per_dollar = [1.2, 0.5, 0.1];

float: MAX_AVG_LOSE = 0.30;

% Use integer dollars to keep it purely linear for standard MIP/CP backends
array[BETS] of var 0..BUDGET: x;

constraint sum(i in BETS)(x[i]) = BUDGET;

% Scale probabilities by 100 to avoid floating-point constraints:
% 0.50 -> 50, 0.25 -> 25, 0.10 -> 10, 0.30 -> 30
array[BETS] of int: lose_pct = [50, 25, 10];
int: MAX_AVG_LOSE_PCT = 30;

constraint sum(i in BETS)(lose_pct[i] * x[i]) <= MAX_AVG_LOSE_PCT * BUDGET;

% Objective (also scaled by 10 to keep integer arithmetic):
% 1.2 -> 12, 0.5 -> 5, 0.1 -> 1
array[BETS] of int: payout_x10 = [12, 5, 1];

solve maximize sum(i in BETS)(payout_x10[i] * x[i]);

output [
  "basketball = ", show(x[1]), "\n",
  "horse      = ", show(x[2]), "\n",
  "soccer     = ", show(x[3]), "\n",
  "objective (x10 dollars) = ", show(sum(i in BETS)(payout_x10[i] * x[i])), "\n"
];