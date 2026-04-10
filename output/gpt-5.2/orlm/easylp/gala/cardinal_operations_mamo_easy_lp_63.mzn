% Bandwidth allocation for services X and Y (all integer Mbps)
% Data embedded as required.

int: maxBandwidth = 10000;
int: minEffectiveness = 5000;

int: effX = 2;   % effectiveness points per Mbps of X
int: effY = 3;   % effectiveness points per Mbps of Y

% Costs are given as $0.2 and $0.3 per Mbps.
% Use integer cents to avoid floating-point issues.
int: costX_cents = 20;
int: costY_cents = 30;

var 0..maxBandwidth: x;  % Mbps for service X
var 0..maxBandwidth: y;  % Mbps for service Y

constraint x + y <= maxBandwidth;
constraint effX * x + effY * y >= minEffectiveness;

var 0..(maxBandwidth * max(costX_cents, costY_cents)): totalCost_cents =
    costX_cents * x + costY_cents * y;

solve minimize totalCost_cents;

output [
  "x (Mbps) = ", show(x), "\n",
  "y (Mbps) = ", show(y), "\n",
  "Total cost ($) = ", show(totalCost_cents div 100), ".", 
  if (totalCost_cents mod 100) < 10 then "0" else "" endif,
  show(totalCost_cents mod 100), "\n"
];