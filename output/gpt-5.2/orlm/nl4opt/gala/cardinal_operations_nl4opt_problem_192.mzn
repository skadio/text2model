% Gamble allocation: maximize expected payout subject to average loss probability <= 30%
% All data embedded as requested.

include "globals.mzn";

int: BUDGET = 100000;

set of int: BETS = 1..3;
int: BASKETBALL = 1;
int: HORSE      = 2;
int: SOCCER     = 3;

array[BETS] of int: losePct   = [50, 25, 10];   % percent chance to lose on each bet
array[BETS] of int: payoutPct = [120, 50, 10];  % payout per $1 as percent (1.2, 0.5, 0.1)

int: maxAvgLosePct = 30;

% Decision variables: dollars allocated to each bet (integer dollars)
array[BETS] of var 0..BUDGET: x;

% Budget constraint
constraint sum(b in BETS)(x[b]) = BUDGET;

% Average chance of losing (weighted by money) <= 30%
% sum(x[b] * losePct[b]) / BUDGET <= 30  ->  sum(x[b]*losePct[b]) <= 30*BUDGET
constraint sum(b in BETS)(x[b] * losePct[b]) <= maxAvgLosePct * BUDGET;

% Objective: maximize average payout (equivalently total payout)
% Total payout = sum(x[b] * payoutPct[b]/100). Multiply by 100 for integer objective.
var int: totalPayoutTimes100 = sum(b in BETS)(x[b] * payoutPct[b]);

solve maximize totalPayoutTimes100;

output [
  "Allocation (dollars):\n",
  "  Basketball: ", show(x[BASKETBALL]), "\n",
  "  Horse:      ", show(x[HORSE]), "\n",
  "  Soccer:     ", show(x[SOCCER]), "\n\n",
  "Avg loss % = ",
  show( (sum(b in BETS)(x[b] * losePct[b])) div BUDGET ), " (integer floor)\n",
  "Total payout = $", show(totalPayoutTimes100 div 100), ".", 
  if (totalPayoutTimes100 mod 100) < 10 then "0" else "" endif,
  show(totalPayoutTimes100 mod 100), "\n"
];