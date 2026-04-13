% Healthy Pet Foods - Profit Maximization (all data embedded)

int: N = 2;
set of int: P = 1..N;

% Products: 1=Meaties, 2=Yummies
array[P] of string: name = ["Meaties", "Yummies"];

% Selling price ($/pack)
array[P] of float: price = [2.80, 2.00];

% Variable mixing/packaging cost ($/pack)
array[P] of float: var_cost = [0.25, 0.20];

% Raw material usage per pack (lbs/pack)
array[P] of float: grains_per_pack = [2.0, 3.0];
array[P] of float: meat_per_pack   = [3.0, 1.5];

% Raw material availability (lbs/month)
float: grains_avail = 400000.0;
float: meat_avail   = 300000.0;

% Raw material purchase prices ($/lb)
float: grains_cost_per_lb = 0.20;
float: meat_cost_per_lb   = 0.50;

% Special machine capacity for Meaties (packs/month)
int: meaties_cap = 90000;

% Decision variables: packs produced/sold per month (nonnegative integers)
array[P] of var int: x;
constraint forall(i in P)(x[i] >= 0);

% Resource constraints
constraint sum(i in P)(grains_per_pack[i] * int2float(x[i])) <= grains_avail;
constraint sum(i in P)(meat_per_pack[i]   * int2float(x[i])) <= meat_avail;

% Machine capacity for Meaties
constraint x[1] <= meaties_cap;

% Profit calculation
var float: revenue =
  sum(i in P)(price[i] * int2float(x[i]));

var float: mixing_packaging_cost =
  sum(i in P)(var_cost[i] * int2float(x[i]));

var float: raw_material_cost =
  grains_cost_per_lb * sum(i in P)(grains_per_pack[i] * int2float(x[i])) +
  meat_cost_per_lb   * sum(i in P)(meat_per_pack[i]   * int2float(x[i]));

var float: profit = revenue - mixing_packaging_cost - raw_material_cost;

solve maximize profit;

output [
  "Optimal monthly production plan:\n",
  concat([ name[i] ++ " packs = " ++ show(x[i]) ++ "\n" | i in P ]),
  "\nTotals:\n",
  "Revenue ($) = ", show(revenue), "\n",
  "Raw material cost ($) = ", show(raw_material_cost), "\n",
  "Mixing/packaging cost ($) = ", show(mixing_packaging_cost), "\n",
  "Profit ($) = ", show(profit), "\n",
  "\nResource usage:\n",
  "Grains used (lbs) = ", show(sum(i in P)(grains_per_pack[i] * int2float(x[i]))), " / ", show(grains_avail), "\n",
  "Meat used (lbs) = ", show(sum(i in P)(meat_per_pack[i] * int2float(x[i]))), " / ", show(meat_avail), "\n",
  "Meaties capacity used (packs) = ", show(x[1]), " / ", show(meaties_cap), "\n"
];