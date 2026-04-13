% Healthy Pet Foods - Profit maximization (LP as integer packs)
% All data embedded as requested.

% ---------- Data ----------
float: price_meaties  = 2.80;
float: price_yummies  = 2.00;

float: grain_meaties  = 2.0;   % lbs per pack
float: grain_yummies  = 3.0;

float: meat_meaties   = 3.0;
float: meat_yummies   = 1.5;

float: varcost_meaties = 0.25; % mixing/packaging per pack
float: varcost_yummies = 0.20;

float: grain_cost = 0.20;      % $ per lb
float: meat_cost  = 0.50;

int: grain_avail = 400000;     % lbs
int: meat_avail  = 300000;     % lbs

int: meaties_cap = 90000;      % packs/month

% ---------- Decision variables ----------
var 0..meaties_cap: M;         % packs of Meaties
var 0..300000: Y;              % packs of Yummies (safe upper bound)

% ---------- Resource constraints ----------
constraint grain_meaties * M + grain_yummies * Y <= grain_avail;
constraint meat_meaties  * M + meat_yummies  * Y <= meat_avail;

% ---------- Profit ----------
% Profit = revenue - raw material costs - variable costs
var float: profit =
    price_meaties * M + price_yummies * Y
  - grain_cost * (grain_meaties * M + grain_yummies * Y)
  - meat_cost  * (meat_meaties  * M + meat_yummies  * Y)
  - varcost_meaties * M - varcost_yummies * Y;

solve maximize profit;

output [
  "Optimal production plan:\n",
  "  Meaties packs (M) = ", show(M), "\n",
  "  Yummies packs (Y) = ", show(Y), "\n\n",
  "Resource usage:\n",
  "  Grains used = ", show(grain_meaties * M + grain_yummies * Y), " lbs (<= ", show(grain_avail), ")\n",
  "  Meat used   = ", show(meat_meaties * M + meat_yummies * Y), " lbs (<= ", show(meat_avail), ")\n\n",
  "Monthly profit = $", show(profit), "\n"
];