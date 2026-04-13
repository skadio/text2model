% World Cup securities: maximize worst-case revenue

% Parameters
int: nSecurities = 5;
int: nOutcomes = 5;

set of int: SEC = 1..nSecurities;
set of int: OUT = 1..nOutcomes;

% Outcome order (OUT=1..5): Argentina, Brazil, England, Germany, Spain
array[SEC] of float: price = [0.75, 0.35, 0.40, 0.75, 0.65];
array[SEC] of int: shareLimit = [10, 5, 10, 10, 5];

array[SEC, OUT] of int: payoff = array2d(SEC, OUT, [
  % Security 1
  1, 1, 1, 0, 0,
  % Security 2
  0, 0, 0, 1, 1,
  % Security 3
  1, 0, 1, 0, 1,
  % Security 4
  1, 1, 1, 1, 0,
  % Security 5
  0, 1, 0, 1, 1
]);

% Variables
array[SEC] of var 0..10: x;     % shares bought
var float: worstCaseRevenue;

% Share limits
constraint forall(s in SEC) (x[s] <= shareLimit[s]);

% Coarse bounds for worstCaseRevenue (optional but helpful)
constraint worstCaseRevenue >= -sum(s in SEC)(price[s] * int2float(shareLimit[s]));
constraint worstCaseRevenue <=  sum(s in SEC)((1.0 - price[s]) * int2float(shareLimit[s]));

% Worst-case revenue linkage:
% realized revenue under outcome o = sum_s (payoff[s,o] - price[s]) * x[s]
constraint forall(o in OUT) (
  worstCaseRevenue <=
    sum(s in SEC)(
      (int2float(payoff[s,o]) - price[s]) * int2float(x[s])
    )
);

solve maximize worstCaseRevenue;