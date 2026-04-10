% Parameters
% Total money available to allocate across bets
int: total_budget = 100000;

% Number of bets (1=basketball, 2=horse race, 3=soccer)
int: n_bets = 3;
set of int: BETS = 1..n_bets;

% Probability of losing money on each bet (percent; kept integer)
array[BETS] of int: lose_prob_pct = [50, 25, 10];

% Payout per dollar bet on each bet (tenths of dollars; 1.2->12, 0.5->5, 0.1->1)
array[BETS] of int: payout_per_dollar_tenths = [12, 5, 1];

% Maximum allowed average chance of losing money (percent)
int: max_avg_lose_prob_pct = 30;

% Variables
% Amount of money to allocate to each bet (in dollars)
array[BETS] of var 0..total_budget: stake;

% Total expected payout in tenths of dollars (scaled)
var 0..(total_budget * max(payout_per_dollar_tenths)): total_payout_tenths;

% Constraints
% Budget allocation constraint: all available money must be allocated
constraint sum(b in BETS)(stake[b]) = total_budget;

% Average loss-probability (weighted by stake) must not exceed the allowed maximum.
% Integer form: sum(stake[b] * lose_prob_pct[b]) <= max_avg_lose_prob_pct * total_budget
constraint
  sum(b in BETS)(stake[b] * lose_prob_pct[b]) <= max_avg_lose_prob_pct * total_budget;

% Define total expected payout (scaled in tenths of dollars)
constraint
  total_payout_tenths = sum(b in BETS)(stake[b] * payout_per_dollar_tenths[b]);

% Objective
solve maximize total_payout_tenths;