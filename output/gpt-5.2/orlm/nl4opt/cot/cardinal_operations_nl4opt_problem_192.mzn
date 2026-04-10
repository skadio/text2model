% Parameters (with values embedded)
int: budget = 100000;

set of int: Bets = 1..3;
int: BASKETBALL = 1;
int: HORSE = 2;
int: SOCCER = 3;

array[Bets] of float: loseProb = [0.50, 0.25, 0.10];
array[Bets] of float: payoutPerDollar = [1.2, 0.5, 0.1];

float: maxAvgLoseProb = 0.30;

% Variables
array[Bets] of var 0..budget: x; % dollars bet on each option
var float: totalPayout;

% Constraints
constraint sum(b in Bets)(x[b]) = budget;

% Average chance of losing money (weighted by amount bet) <= 30%
constraint sum(b in Bets)(loseProb[b] * x[b]) <= maxAvgLoseProb * budget;

% Objective
constraint totalPayout = sum(b in Bets)(payoutPerDollar[b] * x[b]);

solve maximize totalPayout;