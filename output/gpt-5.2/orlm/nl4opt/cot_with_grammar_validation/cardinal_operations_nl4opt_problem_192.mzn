int: budget = 100000;

int: N = 3;
set of int: BETS = 1..N;

array[BETS] of float: lose_prob = [0.50, 0.25, 0.10];
array[BETS] of float: payout_per_dollar = [1.2, 0.5, 0.1];

float: max_avg_lose_prob = 0.30;

array[BETS] of var 0..budget: x;

var float: total_payout;

constraint sum(b in BETS)(x[b]) = budget;

constraint sum(b in BETS)(lose_prob[b] * int2float(x[b])) <= max_avg_lose_prob * int2float(budget);

constraint total_payout = sum(b in BETS)(payout_per_dollar[b] * int2float(x[b]));

solve maximize total_payout;

output [
  "x = ", show(x), "\n",
  "total_payout = ", show(total_payout), "\n"
];