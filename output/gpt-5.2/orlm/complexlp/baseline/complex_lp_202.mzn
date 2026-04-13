% Healthy Pet Food Company profit maximization (embedded data)

% Decision variables: number of packages produced per month
var 0..90000: meaties;           % machine capacity
var 0..400000: yummies;          % loose upper bound; resources will bind

% Data
float: price_meaties = 2.80;
float: price_yummies = 2.00;

float: cereal_per_meaties = 2.0;
float: meat_per_meaties   = 3.0;

float: cereal_per_yummies = 3.0;
float: meat_per_yummies   = 1.5;

int: cereal_avail = 400000; % pounds/month
int: meat_avail   = 300000; % pounds/month

float: cereal_cost = 0.20;  % $/pound
float: meat_cost   = 0.50;  % $/pound

float: pack_cost_meaties = 0.25; % $/package
float: pack_cost_yummies = 0.20; % $/package

% Resource constraints
constraint cereal_per_meaties * meaties + cereal_per_yummies * yummies <= cereal_avail;
constraint meat_per_meaties   * meaties + meat_per_yummies   * yummies <= meat_avail;

% Objective: maximize profit = revenue - ingredient costs - blending/packing costs
var float: profit =
    price_meaties * meaties + price_yummies * yummies
  - cereal_cost * (cereal_per_meaties * meaties + cereal_per_yummies * yummies)
  - meat_cost   * (meat_per_meaties   * meaties + meat_per_yummies   * yummies)
  - pack_cost_meaties * meaties
  - pack_cost_yummies * yummies;

solve maximize profit;

output [
  "Meaties packages: ", show(meaties), "\n",
  "Yummies packages: ", show(yummies), "\n",
  "Profit ($): ", show(profit), "\n",
  "Cereal used (lb): ", show(cereal_per_meaties * meaties + cereal_per_yummies * yummies), "\n",
  "Meat used (lb): ", show(meat_per_meaties * meaties + meat_per_yummies * yummies), "\n"
];