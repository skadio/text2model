% Gamble allocation with risk (average chance of losing) constraint
% Data embedded as requested.

int: budget = 100000;

set of int: B = 1..3;
int: basketball = 1;
int: horse      = 2;
int: soccer     = 3;

array[B] of float: loseProb = [0.50, 0.25, 0.10];
array[B] of float: payoutPerDollar = [1.2, 0.5, 0.1];

float: maxAvgLoseProb = 0.30;

% Decision variables: dollars allocated to each bet
array[B] of var 0..budget: x;

constraint sum(b in B)(x[b]) = budget;

% Weighted-average risk constraint:
% sum(x[b]*loseProb[b]) / budget <= maxAvgLoseProb
% Multiply by budget to avoid division:
constraint sum(b in B)(loseProb[b] * int2float(x[b])) <= maxAvgLoseProb * int2float(budget);

% Objective: maximize expected payout (average payout per dollar is equivalent)
var float: totalPayout = sum(b in B)(payoutPerDollar[b] * int2float(x[b]));
solve maximize totalPayout;

output [
  "Basketball: ", show(x[basketball]), "\n",
  "Horse: ", show(x[horse]), "\n",
  "Soccer: ", show(x[soccer]), "\n",
  "Total payout: ", show(totalPayout), "\n",
  "Average lose probability: ",
    show(sum(b in B)(loseProb[b] * int2float(x[b])) / int2float(budget)), "\n"
];