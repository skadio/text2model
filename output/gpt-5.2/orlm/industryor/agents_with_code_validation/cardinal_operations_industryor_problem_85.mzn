% Healthy Pet Foods - Profit Maximization (integer packs)
% Reformulated to a pure linear integer model (no float var equalities),
% avoiding timeouts from float-domain propagation.

%--------------------------
% Data (embedded)
%--------------------------
int: grains_available = 400000;   % lbs/month
int: meat_available   = 300000;   % lbs/month
int: meaties_capacity = 90000;    % packs/month

% Per-pack requirements (use integers by scaling meat by 2 to remove 1.5)
int: grains_per_meaties = 2;      % lbs/pack
int: grains_per_yummies = 3;      % lbs/pack
int: meat2_per_meaties  = 6;      % (2*lbs)/pack  since 3.0 * 2 = 6
int: meat2_per_yummies  = 3;      % (2*lbs)/pack  since 1.5 * 2 = 3
int: meat2_available    = 2 * meat_available;

% Prices/costs in cents to keep everything integer
int: price_meaties_c    = 280;
int: price_yummies_c    = 200;

int: varcost_meaties_c  = 25;
int: varcost_yummies_c  = 20;

int: grains_cost_c_per_lb = 20;
int: meat_cost_c_per_lb   = 50;

%--------------------------
% Decision variables
%--------------------------
var 0..meaties_capacity: packs_meaties;
% Upper bound for yummies from each resource
int: max_yummies_by_grains = grains_available div grains_per_yummies;
int: max_yummies_by_meat2  = meat2_available div meat2_per_yummies;
var 0..min(max_yummies_by_grains, max_yummies_by_meat2): packs_yummies;

%--------------------------
% Constraints (resource limits)
%--------------------------
constraint grains_per_meaties * packs_meaties + grains_per_yummies * packs_yummies
        <= grains_available;

constraint meat2_per_meaties * packs_meaties + meat2_per_yummies * packs_yummies
        <= meat2_available;

%--------------------------
% Objective: maximize profit (in cents)
% profit = revenue - raw materials - variable costs
% raw materials:
%   grains_cost = 20 * grains_used
%   meat_cost   = 50 * meat_used = 50 * (meat2_used/2) = 25 * meat2_used
%--------------------------
var int: profit_cents =
    (price_meaties_c - varcost_meaties_c) * packs_meaties
  + (price_yummies_c - varcost_yummies_c) * packs_yummies
  - grains_cost_c_per_lb * (grains_per_meaties * packs_meaties + grains_per_yummies * packs_yummies)
  - 25 * (meat2_per_meaties * packs_meaties + meat2_per_yummies * packs_yummies);

solve maximize profit_cents;

output [
  "packs_meaties = ", show(packs_meaties), "\n",
  "packs_yummies = ", show(packs_yummies), "\n",
  "profit ($)    = ", show(profit_cents div 100), ".", show_int(profit_cents mod 100, 2), "\n"
];