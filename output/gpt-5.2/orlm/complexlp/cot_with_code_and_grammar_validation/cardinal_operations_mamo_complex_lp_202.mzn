% Healthy Pet Food Company - Profit maximization
% Use integer arithmetic (scale all money by 100) to avoid float search/timeouts.

% Prices (cents per package)
int: price_meaties_c = 280;
int: price_yummies_c = 200;

% Blending/packing variable costs (cents per package)
int: pack_meaties_c = 25;
int: pack_yummies_c = 20;

% Raw material costs (cents per pound)
int: cereal_cost_c = 20;
int: meat_cost_c   = 50;

% Resource limits (pounds)
int: cereal_avail = 400000;
int: meat_avail   = 300000;

% Per-package resource usage (use halves to model 1.5 lb exactly)
% For Meaties: cereal 2.0 => 4 half-lb, meat 3.0 => 6 half-lb
% For Yummies: cereal 3.0 => 6 half-lb, meat 1.5 => 3 half-lb
int: cereal_meaties_h = 4;
int: meat_meaties_h   = 6;
int: cereal_yummies_h = 6;
int: meat_yummies_h   = 3;

% Capacity
int: cap_meaties = 90000;

% Decision variables (packages)
var 0..cap_meaties: x_meaties;
var 0..200000: x_yummies; % safe upper bound

% Resource usage in half-pounds
var 0..2*cereal_avail: cereal_used_h;
var 0..2*meat_avail: meat_used_h;

constraint cereal_used_h = cereal_meaties_h * x_meaties + cereal_yummies_h * x_yummies;
constraint meat_used_h   = meat_meaties_h   * x_meaties + meat_yummies_h   * x_yummies;

constraint cereal_used_h <= 2 * cereal_avail;
constraint meat_used_h   <= 2 * meat_avail;

% Profit in cents:
% revenue - packing - (material costs based on pounds used)
% pounds_used = half_pounds_used / 2  => divide by 2 (exact since costs are even cents)
var int: profit_c;
constraint profit_c =
    (price_meaties_c - pack_meaties_c) * x_meaties
  + (price_yummies_c - pack_yummies_c) * x_yummies
  - (cereal_cost_c * cereal_used_h + meat_cost_c * meat_used_h) div 2;

solve maximize profit_c;

output [
  "Meaties packages = ", show(x_meaties), "\n",
  "Yummies packages = ", show(x_yummies), "\n",
  "Cereal used (lb) = ", show(cereal_used_h div 2), "\n",
  "Meat used (lb) = ", show(meat_used_h div 2), "\n",
  "Profit ($) = ", show(profit_c / 100.0), "\n"
];