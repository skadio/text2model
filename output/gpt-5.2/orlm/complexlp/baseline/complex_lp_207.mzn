% Rylon Corporation perfume production LP (modeled as MILP with continuous vars)
% All data embedded.

solve maximize profit;

%--------------------------
% Data
%--------------------------
int: lab_hours_available = 6000;
float: raw_cost_per_lb = 3.0;
int: raw_lb_max = 4000;

% Yields from 1 lb raw
float: brute_reg_oz_per_lb = 3.0;
float: chanelle_reg_oz_per_lb = 4.0;

% Selling prices ($/oz)
float: price_reg_brute = 7.0;
float: price_reg_chanelle = 6.0;
float: price_lux_brute = 18.0;
float: price_lux_chanelle = 14.0;

% Further processing requirements and costs
float: hrs_per_oz_lux_brute = 3.0;
float: hrs_per_oz_lux_chanelle = 2.0;
float: extra_cost_per_oz_lux = 4.0; % for both

% Base processing: 1 hr per lb raw
float: hrs_per_lb_raw = 1.0;

%--------------------------
% Decision variables
%--------------------------
var 0.0..raw_lb_max: raw_lb;                 % lb of raw material purchased and processed
var 0.0..1.0e9: reg_brute_sold_oz;
var 0.0..1.0e9: reg_chanelle_sold_oz;
var 0.0..1.0e9: lux_brute_oz;
var 0.0..1.0e9: lux_chanelle_oz;

%--------------------------
% Constraints
%--------------------------
constraint reg_brute_sold_oz + lux_brute_oz
           <= brute_reg_oz_per_lb * raw_lb;

constraint reg_chanelle_sold_oz + lux_chanelle_oz
           <= chanelle_reg_oz_per_lb * raw_lb;

constraint hrs_per_lb_raw * raw_lb
         + hrs_per_oz_lux_brute * lux_brute_oz
         + hrs_per_oz_lux_chanelle * lux_chanelle_oz
         <= lab_hours_available;

%--------------------------
% Objective: maximize profit
% (Lab hours are fixed cost => not included in objective)
%--------------------------
var float: revenue =
    price_reg_brute * reg_brute_sold_oz
  + price_reg_chanelle * reg_chanelle_sold_oz
  + price_lux_brute * lux_brute_oz
  + price_lux_chanelle * lux_chanelle_oz;

var float: cost =
    raw_cost_per_lb * raw_lb
  + extra_cost_per_oz_lux * (lux_brute_oz + lux_chanelle_oz);

var float: profit = revenue - cost;

%--------------------------
% Output
%--------------------------
output [
  "raw_lb = ", show(raw_lb), "\n",
  "reg_brute_sold_oz = ", show(reg_brute_sold_oz), "\n",
  "reg_chanelle_sold_oz = ", show(reg_chanelle_sold_oz), "\n",
  "lux_brute_oz = ", show(lux_brute_oz), "\n",
  "lux_chanelle_oz = ", show(lux_chanelle_oz), "\n",
  "revenue = ", show(revenue), "\n",
  "cost = ", show(cost), "\n",
  "max_profit = ", show(profit), "\n"
];