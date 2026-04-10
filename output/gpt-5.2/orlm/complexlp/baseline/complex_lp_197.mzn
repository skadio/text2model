% World Cup securities: maximize worst-case revenue (payoff - cost)
% Data embedded as given in the description.

int: S = 5;  % securities
int: C = 5;  % countries (states)

set of int: SEC = 1..S;
set of int: COU = 1..C;

% Country index mapping:
% 1 Argentina, 2 Brazil, 3 England, 4 Germany, 5 Spain

array[SEC] of int: shareLimit = [10, 5, 10, 10, 5];

% Prices in cents to keep integer model
array[SEC] of int: priceCents = [75, 35, 40, 75, 65];

% Payoff matrix in cents (here payoffs are $1 or $0 => 100 or 0 cents)
array[SEC, COU] of int: payoffCents =
array2d(SEC, COU, [
  % A    B    E    G    S
  100, 100, 100,   0,   0,   % Security 1
    0,   0,   0, 100, 100,   % Security 2
  100,   0, 100,   0, 100,   % Security 3
  100, 100, 100, 100,   0,   % Security 4
    0, 100,   0, 100, 100    % Security 5
]);

% Decision: number of shares to buy of each security
array[SEC] of var 0..max(shareLimit): x;

constraint forall(s in SEC)(x[s] <= shareLimit[s]);

% Total cost (cents)
var int: costCents = sum(s in SEC)(priceCents[s] * x[s]);

% Net revenue in each country (cents): payoff - cost
array[COU] of var int: netRevenueCents;
constraint forall(c in COU)(
  netRevenueCents[c] = sum(s in SEC)(payoffCents[s,c] * x[s]) - costCents
);

% Worst-case revenue (cents)
var int: worstCents;
constraint forall(c in COU)(worstCents <= netRevenueCents[c]);

solve maximize worstCents;

% Output: report in dollars, rounded to nearest dollar (half-up)
function int: round_nearest_dollar(var int: cents) =
  if cents >= 0 then (cents + 50) div 100 else - ((-cents + 50) div 100) endif;

output [
  "x = ", show(x), "\n",
  "worst_case_revenue_cents = ", show(worstCents), "\n",
  "worst_case_revenue_rounded_dollars = ", show(round_nearest_dollar(worstCents)), "\n"
];