% Carelland exports model (all data embedded)
% Maximize GDP (export value) minus imports of "other imported goods"

int: nCommodities = 4;
set of int: C = 1..nCommodities;

int: STEEL = 1;
int: ENGINES = 2;
int: ELECTRONICS = 3;
int: PLASTIC = 4;

% World market unit prices (Klunz per unit)
array[C] of int: price = [500, 1500, 300, 1200];

% Input coefficients a[i,j]: units of input i needed to produce 1 unit of output j
array[C, C] of float: a =
  [| 0.0,  0.8,  0.01, 0.2
   | 0.02, 0.0,  0.01, 0.03
   | 0.0,  0.15, 0.0,  0.05
   | 0.01, 0.11, 0.05, 0.0
  |];

% Imported goods (Klunz) needed per unit produced
array[C] of int: imported_goods = [250, 300, 50, 300];

% Labor requirements in person-months per unit produced (1 person-year = 12 pm)
array[C] of int: labor_pm = [6, 12, 6, 24];

% Capacity limits (units); use BIG for "no explicit limit"
int: BIG = 1000000000;
array[C] of int: max_prod = [BIG, 650000, BIG, 60000];

% Total labor available per year (person-months)
int: labor_available_pm = 830000;

% --- Safe upper bounds to avoid int overflow in bounds/expressions ---
% Labor bound implies prod[c] <= labor_available_pm div labor_pm[c]
array[C] of int: labor_ub = [labor_available_pm div labor_pm[c] | c in C];

% Use the tightest known upper bound per commodity
array[C] of int: ub = [min(max_prod[c], labor_ub[c]) | c in C];

% Upper bounds for derived variables (kept within 32-bit int range)
int: max_imports = sum(c in C)(imported_goods[c] * ub[c]);
int: max_gdp     = sum(c in C)(price[c] * ub[c]);

% Variables
array[C] of var 0..ub[c]: prod;

var 0..max_imports: total_imported_goods;
var 0..labor_available_pm: total_labor_used;
var 0..max_gdp: gdp;

% Constraints

% Capacity limits on production (by commodity)
constraint forall(c in C) (prod[c] <= max_prod[c]);

% Intermediate input balance:
% For each commodity i, total domestic use as an input to all productions
% cannot exceed domestic production of i (no external imports of these commodities).
constraint
  forall(i in C) (
    sum(j in C)(a[i,j] * int2float(prod[j])) <= int2float(prod[i])
  );

% Imported goods accounting
constraint
  total_imported_goods = sum(c in C)(imported_goods[c] * prod[c]);

% Labor accounting and availability
constraint
  total_labor_used = sum(c in C)(labor_pm[c] * prod[c]);
constraint
  total_labor_used <= labor_available_pm;

% GDP / export value proxy definition
constraint
  gdp = sum(c in C)(price[c] * prod[c]);

% Objective: maximize GDP minus imported goods cost
solve maximize (gdp - total_imported_goods);

output [
  "prod_steel=", show(prod[STEEL]), "\n",
  "prod_engines=", show(prod[ENGINES]), "\n",
  "prod_electronics=", show(prod[ELECTRONICS]), "\n",
  "prod_plastic=", show(prod[PLASTIC]), "\n",
  "gdp=", show(gdp), "\n",
  "imports=", show(total_imported_goods), "\n",
  "labor_used=", show(total_labor_used), "\n",
  "net_objective=", show(gdp - total_imported_goods), "\n"
];