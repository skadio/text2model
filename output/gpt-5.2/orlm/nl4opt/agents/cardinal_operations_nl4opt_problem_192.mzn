% Parameters
int: total_budget = 100000;                              % Total money available to bet

set of int: BETS = 1..3;                                 % 1=basketball, 2=horse, 3=soccer

array[BETS] of float: lose_prob = [0.50, 0.25, 0.10];     % Probability of losing money for each bet
array[BETS] of float: payout_per_dollar = [1.2, 0.5, 0.1];% Payout per $1 bet for each bet

float: max_avg_lose_prob = 0.30;                         % Maximum allowed average probability of losing


% Variables
array[BETS] of var 0..total_budget: bet_amount;          % Amount of money to bet on each sport (in dollars)

var 0.0..(max(lose_prob) * int2float(total_budget)): avg_lose_risk;   % Expected amount at risk (weighted by loss probs)
var 0.0..(max(payout_per_dollar) * int2float(total_budget)): total_payout; % Total payout


% Constraints
% --- Budget feasibility: cannot bet more than the available total budget ---
constraint
  sum(b in BETS)(bet_amount[b]) <= total_budget;

% --- Define total payout as the weighted sum of bet amounts by payout rates ---
constraint
  total_payout =
    sum(b in BETS)(payout_per_dollar[b] * int2float(bet_amount[b]));

% --- Define average losing risk (expected amount lost) as weighted sum by loss probabilities ---
constraint
  avg_lose_risk =
    sum(b in BETS)(lose_prob[b] * int2float(bet_amount[b]));

% --- Risk limit: average chance of losing (weighted by stake) must be at most 30% of total budget ---
constraint
  avg_lose_risk <= max_avg_lose_prob * int2float(total_budget);


% Objective
solve maximize total_payout;