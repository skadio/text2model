% Rylon perfume profit maximization (LP)
% Use a MIP-style formulation with scaling to cents to avoid floating-point slowdowns.

int: SCALE = 100; % dollars -> cents

% Parameters (scaled to cents where applicable)
int: raw_cost_per_lb = 3 * SCALE;

int: raw_to_reg_brute_oz_per_lb = 3;
int: raw_to_reg_chanelle_oz_per_lb = 4;

int: price_reg_brute_per_oz = 7 * SCALE;
int: price_reg_chanelle_per_oz = 6 * SCALE;
int: price_lux_brute_per_oz = 18 * SCALE;
int: price_lux_chanelle_per_oz = 14 * SCALE;

int: extra_cost_lux_per_oz = 4 * SCALE;

int: lab_hours_per_lb_raw = 1;
int: lab_hours_per_oz_lux_brute = 3;
int: lab_hours_per_oz_lux_chanelle = 2;

int: lab_hours_available = 6000;
int: raw_lb_max = 4000;

% Upper bounds on ounces from max raw
int: max_reg_brute_oz = raw_to_reg_brute_oz_per_lb * raw_lb_max;      % 12000
int: max_reg_chanelle_oz = raw_to_reg_chanelle_oz_per_lb * raw_lb_max; % 16000

% Decision variables (integer amounts)
var 0..raw_lb_max: raw_lb;

% Regular ounces sold
var 0..max_reg_brute_oz: reg_brute_sold_oz;
var 0..max_reg_chanelle_oz: reg_chanelle_sold_oz;

% Luxury ounces produced (from further processing)
var 0..max_reg_brute_oz: lux_brute_oz;
var 0..max_reg_chanelle_oz: lux_chanelle_oz;

% Profit in cents
var int: profit_cents;

% Material balance: all regular output either sold as regular or converted to luxury
constraint reg_brute_sold_oz + lux_brute_oz = raw_to_reg_brute_oz_per_lb * raw_lb;
constraint reg_chanelle_sold_oz + lux_chanelle_oz = raw_to_reg_chanelle_oz_per_lb * raw_lb;

% Laboratory hours (raw processing + further processing)
constraint
  lab_hours_per_lb_raw * raw_lb
  + lab_hours_per_oz_lux_brute * lux_brute_oz
  + lab_hours_per_oz_lux_chanelle * lux_chanelle_oz
  <= lab_hours_available;

% Profit = revenues - raw material cost - extra processing cost
constraint
  profit_cents =
      price_reg_brute_per_oz * reg_brute_sold_oz
    + price_reg_chanelle_per_oz * reg_chanelle_sold_oz
    + price_lux_brute_per_oz * lux_brute_oz
    + price_lux_chanelle_per_oz * lux_chanelle_oz
    - raw_cost_per_lb * raw_lb
    - extra_cost_lux_per_oz * (lux_brute_oz + lux_chanelle_oz);

solve maximize profit_cents;

output [
  "raw_lb=", show(raw_lb), "\n",
  "reg_brute_sold_oz=", show(reg_brute_sold_oz), "\n",
  "reg_chanelle_sold_oz=", show(reg_chanelle_sold_oz), "\n",
  "lux_brute_oz=", show(lux_brute_oz), "\n",
  "lux_chanelle_oz=", show(lux_chanelle_oz), "\n",
  "profit=$", show(profit_cents div SCALE), ".", show((profit_cents mod SCALE) div 10), show((profit_cents mod SCALE) mod 10), "\n"
];