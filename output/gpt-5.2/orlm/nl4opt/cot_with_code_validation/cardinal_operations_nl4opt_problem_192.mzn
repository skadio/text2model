% Data (embedded)
int: budget = 100000;

set of int: B = 1..3; % 1=basketball, 2=horse, 3=soccer

array[B] of int: lose_prob_scaled = [50, 25, 10];  % probabilities * 100
array[B] of int: payout_scaled    = [12,  5,  1];  % payout per $ * 10

int: max_avg_lose_prob_scaled = 30; % 0.30 * 100

% Decision variables (integer dollars bet)
array[B] of var 0..budget: x;

% Constraints
constraint sum(b in B)(x[b]) = budget;

% Weighted average losing probability <= 0.30:
% sum(lose_prob[b] * x[b]) / budget <= 0.30
% Using scaling by 100 avoids float linear limitations:
constraint sum(b in B)(lose_prob_scaled[b] * x[b]) <= max_avg_lose_prob_scaled * budget;

% Objective (maximize total payout; constant scaling by 10 is fine)
var int: total_payout_scaled = sum(b in B)(payout_scaled[b] * x[b]);

solve maximize total_payout_scaled;

output [
  "basketball_bet = ", show(x[1]), "\n",
  "horse_bet      = ", show(x[2]), "\n",
  "soccer_bet     = ", show(x[3]), "\n",
  "total_payout   = ", show(int2float(total_payout_scaled) / 10.0), "\n"
];