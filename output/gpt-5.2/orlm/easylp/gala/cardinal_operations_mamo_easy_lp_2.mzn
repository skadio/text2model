% Marketing campaign spending optimization (integers)
% Minimize total spend subject to effectiveness and balance constraints.

int: min_effectiveness = 100;

% Impact point contributions per dollar
int: adv_points = 4;
int: promo_points = 5;

% Balance constraint: advertising cannot exceed promotion by more than $50
int: max_adv_over_promo = 50;

% Decision variables (integer dollars)
var 0..100000: adv;    % advertising spend
var 0..100000: promo;  % promotion spend

% Effectiveness constraint
constraint adv_points * adv + promo_points * promo >= min_effectiveness;

% Balance constraint
constraint adv - promo <= max_adv_over_promo;

% Objective: minimize total spend
var 0..200000: total = adv + promo;

solve minimize total;

output [
  "Advertising = ", show(adv), "\n",
  "Promotion   = ", show(promo), "\n",
  "Total       = ", show(total), "\n",
  "Effectiveness points = ", show(adv_points*adv + promo_points*promo), "\n"
];