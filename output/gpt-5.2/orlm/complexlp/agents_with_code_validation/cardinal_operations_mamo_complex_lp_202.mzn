% Healthy Pet Food Company - Profit maximization
% Use integer arithmetic (in cents and half-pounds) to avoid slow float solving.

% Prices (cents per package)
int: price_meaties_c = 280;
int: price_yummies_c = 200;

% Blending/packing costs (cents per package)
int: pack_meaties_c = 25;
int: pack_yummies_c = 20;

% Raw material costs (cents per pound)
int: cost_cereal_c_per_lb = 20;
int: cost_meat_c_per_lb   = 50;

% Resource usage per package (in half-pounds per package)
% (1 lb = 2 half-lb)
int: cereal_meaties_hlb = 4;   % 2.0 lb
int: meat_meaties_hlb   = 6;   % 3.0 lb
int: cereal_yummies_hlb = 6;   % 3.0 lb
int: meat_yummies_hlb   = 3;   % 1.5 lb

% Availability (in half-pounds)
int: cereal_avail_hlb = 800000; % 400,000 lb
int: meat_avail_hlb   = 600000; % 300,000 lb

% Capacity
int: meaties_capacity = 90000;

% Decision variables (packages)
var 0..meaties_capacity: x_meaties;
var 0..133333: x_yummies; % safe upper bound (<= 800000/6 and <= 600000/3)

% Resource constraints (half-pounds)
constraint cereal_meaties_hlb * x_meaties + cereal_yummies_hlb * x_yummies <= cereal_avail_hlb;
constraint meat_meaties_hlb   * x_meaties + meat_yummies_hlb   * x_yummies <= meat_avail_hlb;

% Profit in cents:
% raw cost: cereal (20 cents/lb) => 10 cents/half-lb
%           meat   (50 cents/lb) => 25 cents/half-lb
var int: profit_cents =
  (price_meaties_c * x_meaties + price_yummies_c * x_yummies)
  - (pack_meaties_c * x_meaties + pack_yummies_c * x_yummies)
  - (10 * (cereal_meaties_hlb * x_meaties + cereal_yummies_hlb * x_yummies))
  - (25 * (meat_meaties_hlb * x_meaties + meat_yummies_hlb * x_yummies));

solve maximize profit_cents;

output [
  "Meaties packages = ", show(x_meaties), "\n",
  "Yummies packages = ", show(x_yummies), "\n",
  "Profit (cents) = ", show(profit_cents), "\n",
  "Profit ($) = ", show(profit_cents div 100), ".", show((profit_cents mod 100) div 10), show(profit_cents mod 10), "\n"
];