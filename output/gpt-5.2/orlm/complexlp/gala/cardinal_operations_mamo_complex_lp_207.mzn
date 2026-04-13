% Rylon Corporation Perfume Planning (LP, maximize profit)
% All data embedded as per instructions.

include "globals.mzn";

% -----------------------------
% Data (from problem statement)
% -----------------------------
int: lab_hours_available = 6000;
int: raw_lb_max = 4000;

float: raw_cost_per_lb = 3.0;

% Yields per lb of processed raw material (oz)
float: brute_reg_yield_per_lb = 3.0;
float: chanelle_reg_yield_per_lb = 4.0;

% Regular selling prices ($/oz)
float: brute_reg_price = 7.0;
float: chanelle_reg_price = 6.0;

% Luxury selling prices ($/oz)
float: brute_lux_price = 18.0;
float: chanelle_lux_price = 14.0;

% Further processing requirements and costs
float: brute_further_hours_per_oz = 3.0;
float: chanelle_further_hours_per_oz = 2.0;
float: further_cost_per_oz = 4.0;

% Lab time to process raw material: 1 hour per lb
float: base_hours_per_lb = 1.0;

% -----------------------------
% Decision variables
% -----------------------------
% x = lb of raw material purchased & processed
var 0.0..raw_lb_max: x;

% Further processing (oz converted from regular to luxury)
var 0.0..(brute_reg_yield_per_lb * raw_lb_max): yB;  % oz of Regular Brute further processed to Luxury
var 0.0..(chanelle_reg_yield_per_lb * raw_lb_max): yC; % oz of Regular Chanelle further processed to Luxury

% Derived amounts sold as regular (oz)
var 0.0..(brute_reg_yield_per_lb * raw_lb_max): rB;
var 0.0..(chanelle_reg_yield_per_lb * raw_lb_max): rC;

% -----------------------------
% Constraints
% -----------------------------
% Material balance: regular output from x is split into sold-regular and further-processed
constraint rB + yB = brute_reg_yield_per_lb * x;
constraint rC + yC = chanelle_reg_yield_per_lb * x;

% Laboratory hours limit (lab hours cost is fixed, so not in objective)
constraint base_hours_per_lb * x
         + brute_further_hours_per_oz * yB
         + chanelle_further_hours_per_oz * yC
         <= lab_hours_available;

% Raw material purchase bound (already in domain, but kept explicit)
constraint x <= raw_lb_max;

% -----------------------------
% Objective: maximize profit
% -----------------------------
% Revenue:
%   regular sales: rB*7 + rC*6
%   luxury sales:  yB*18 + yC*14
% Costs:
%   raw purchase: 3*x
%   further processing: 4*(yB+yC)
var float: profit =
    brute_reg_price * rB
  + chanelle_reg_price * rC
  + brute_lux_price * yB
  + chanelle_lux_price * yC
  - raw_cost_per_lb * x
  - further_cost_per_oz * (yB + yC);

solve maximize profit;

output [
  "Max profit = $", show(profit), "\n",
  "Raw processed (lb) x = ", show(x), "\n",
  "Regular Brute sold (oz) rB = ", show(rB), "\n",
  "Regular Chanelle sold (oz) rC = ", show(rC), "\n",
  "Luxury Brute made/sold (oz) yB = ", show(yB), "\n",
  "Luxury Chanelle made/sold (oz) yC = ", show(yC), "\n",
  "Lab hours used = ",
    show(base_hours_per_lb * x
       + brute_further_hours_per_oz * yB
       + chanelle_further_hours_per_oz * yC),
  " / ", show(lab_hours_available), "\n"
];