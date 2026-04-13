% Parameters
int: S = 5; % securities
int: C = 5; % countries (states)

set of int: SEC = 1..S;
set of int: CTY = 1..C;

% Countries index mapping:
% 1=Argentina, 2=Brazil, 3=England, 4=Germany, 5=Spain

array[SEC] of int: shareLimit = [10, 5, 10, 10, 5];

% Use cents to avoid floating-point: priceCents = round(price * 100)
array[SEC] of int: priceCents = [75, 35, 40, 75, 65];

% Payoff is $1 or $0, represent in cents (100 or 0)
array[SEC, CTY] of int: payoffCents =
  [| 100,100,100,  0,  0  % Security 1
   |   0,  0,  0,100,100  % Security 2
   | 100,  0,100,  0,100  % Security 3
   | 100,100,100,100,  0  % Security 4
   |   0,100,  0,100,100  % Security 5
   |];

% Variables
array[SEC] of var 0..10: x;        % shares bought of each security (bounded further by shareLimit)
var int: worstRevenueCents;        % maximum worst-case revenue in cents

% Constraints
constraint
  forall(s in SEC) (x[s] <= shareLimit[s]);

% worstRevenueCents <= revenue in every country
constraint
  forall(c in CTY) (
    worstRevenueCents <=
      sum(s in SEC) (payoffCents[s,c] * x[s]) - sum(s in SEC) (priceCents[s] * x[s])
  );

% (Optional tightening) lower bound on worstRevenueCents
constraint worstRevenueCents >= -sum(s in SEC) (priceCents[s] * shareLimit[s]);

% Objective
solve maximize worstRevenueCents;