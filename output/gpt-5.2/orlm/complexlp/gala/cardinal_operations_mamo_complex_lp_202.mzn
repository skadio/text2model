% Healthy Pet Food Company - Profit Maximization
% All data embedded as requested.

% Decision variables (packages per month)
var 0..90000: meaties;          % limited by special machine capacity
var 0..1000000: yummies;        % upper bound set large enough

% Data
float: price_M = 2.80;
float: price_Y = 2.00;

float: cereal_per_M = 2.0;
float: meat_per_M   = 3.0;

float: cereal_per_Y = 3.0;
float: meat_per_Y   = 1.5;

float: cereal_avail = 400000.0;
float: meat_avail   = 300000.0;

float: cereal_cost  = 0.20;
float: meat_cost    = 0.50;

float: pack_cost_M  = 0.25;
float: pack_cost_Y  = 0.20;

% Resource constraints
constraint cereal_per_M * int2float(meaties) + cereal_per_Y * int2float(yummies) <= cereal_avail;
constraint meat_per_M   * int2float(meaties) + meat_per_Y   * int2float(yummies) <= meat_avail;

% Objective: maximize profit = revenue - ingredient costs - blending/packing costs
var float: profit =
    (price_M * int2float(meaties) + price_Y * int2float(yummies))
  - cereal_cost * (cereal_per_M * int2float(meaties) + cereal_per_Y * int2float(yummies))
  - meat_cost   * (meat_per_M   * int2float(meaties) + meat_per_Y   * int2float(yummies))
  - (pack_cost_M * int2float(meaties) + pack_cost_Y * int2float(yummies));

solve maximize profit;

output [
  "Meaties packages = ", show(meaties), "\n",
  "Yummies packages = ", show(yummies), "\n",
  "Profit = $", show(profit), "\n",
  "Cereal used (lb) = ",
    show(cereal_per_M * int2float(meaties) + cereal_per_Y * int2float(yummies)), "\n",
  "Meat used (lb) = ",
    show(meat_per_M * int2float(meaties) + meat_per_Y * int2float(yummies)), "\n"
];