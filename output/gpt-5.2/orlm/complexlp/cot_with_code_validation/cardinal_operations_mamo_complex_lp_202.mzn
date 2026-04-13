% Healthy Pet Food Company - Profit Maximization
% Use linear integer arithmetic by scaling all money amounts by 100 (cents)
% and meat usage by 2 to avoid 1.5 (half-pound) fractions.

% Prices and costs (in cents)
int: price_meaties_c  = 280;
int: price_yummies_c  = 200;

int: cereal_cost_c    = 20;   % per pound
int: meat_cost_c      = 50;   % per pound

int: packcost_meaties_c = 25; % per package
int: packcost_yummies_c = 20; % per package

% Resource limits (in pounds)
int: cereal_max = 400000;
int: meat_max   = 300000;

% Per-package resource requirements
int: cereal_per_meaties = 2;  % pounds
int: cereal_per_yummies = 3;  % pounds

% Meat is scaled by 2: meat2 = 2 * meat_in_pounds
int: meat2_per_meaties = 6;   % 2*3.0
int: meat2_per_yummies = 3;   % 2*1.5
int: meat2_max = 2 * meat_max;

% Capacity
int: cap_meaties = 90000;

% Decision variables (packages)
var 0..cap_meaties: meaties;
var 0..200000: yummies; % safe upper bound

% Constraints
constraint cereal_per_meaties * meaties + cereal_per_yummies * yummies <= cereal_max;
constraint meat2_per_meaties * meaties + meat2_per_yummies * yummies <= meat2_max;

% Profit (in cents); meat cost uses meat2 so divide by 2 via integer arithmetic:
% meat_cost_c * (meat2/2)  == (meat_cost_c * meat2) div 2, but since meat2 is even/odd,
% compute as (meat_cost_c * meat2_total) div 2 which is exact here.
var int: profit_cents;
var int: meat2_total = meat2_per_meaties * meaties + meat2_per_yummies * yummies;
var int: cereal_total = cereal_per_meaties * meaties + cereal_per_yummies * yummies;

constraint profit_cents =
    price_meaties_c * meaties + price_yummies_c * yummies
  - cereal_cost_c * cereal_total
  - (meat_cost_c * meat2_total) div 2
  - packcost_meaties_c * meaties
  - packcost_yummies_c * yummies;

solve maximize profit_cents;

output [
  "meaties = ", show(meaties), "\n",
  "yummies = ", show(yummies), "\n",
  "profit_cents = ", show(profit_cents), "\n",
  "profit_dollars = ", show(profit_cents div 100), ".", show((profit_cents mod 100 + 100) mod 100), "\n"
];