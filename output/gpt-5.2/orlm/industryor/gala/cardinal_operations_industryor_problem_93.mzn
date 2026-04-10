% Crude oil blending and purchasing plan (piecewise purchase cost)
% All data embedded as requested.

% ------------ Data ------------
int: invA = 500;          % t crude A in inventory
int: invB = 1000;         % t crude B in inventory
int: maxBuyA = 1500;      % t max purchasable A

float: minA_I  = 0.50;    % min proportion A in gasoline Type I
float: minA_II = 0.60;    % min proportion A in gasoline Type II

int: priceI  = 4800;      % yuan/t selling price Type I
int: priceII = 5600;      % yuan/t selling price Type II

int: c1 = 10000;          % yuan/t for first 500 t of purchase
int: c2 = 8000;           % yuan/t for next 500 t (501..1000)
int: c3 = 6000;           % yuan/t for remainder (1001..1500)

% ------------ Decision variables ------------
% Purchases split into blocks for piecewise pricing
var 0..500: buy1;         % 0..500
var 0..500: buy2;         % 0..500
var 0..500: buy3;         % 0..500
var 0..maxBuyA: buyA = buy1 + buy2 + buy3;

% Production (t) of gasoline types
var 0.0..1.0e9: xI;       % total Type I produced (t)
var 0.0..1.0e9: xII;      % total Type II produced (t)

% Amount of crude A used in each product (t)
var 0.0..1.0e9: aI;
var 0.0..1.0e9: aII;

% ------------ Constraints ------------
% Material balances
constraint aI + aII <= invA + buyA;
constraint (xI - aI) + (xII - aII) <= invB;

% Nonnegativity / feasibility linking
constraint aI <= xI;
constraint aII <= xII;

% Quality constraints (minimum A proportions)
constraint aI  >= minA_I  * xI;
constraint aII >= minA_II * xII;

% ------------ Objective ------------
% Maximize profit = revenue - purchase cost
var float: revenue = priceI * xI + priceII * xII;
var float: costA = c1 * buy1 + c2 * buy2 + c3 * buy3;
var float: profit = revenue - costA;

solve maximize profit;

% ------------ Output ------------
output [
  "Optimal plan:\n",
  "  Purchase crude A total (t) = ", show(buyA), "\n",
  "    buy1 (0..500 at 10000)   = ", show(buy1), "\n",
  "    buy2 (next 500 at 8000)  = ", show(buy2), "\n",
  "    buy3 (rest at 6000)      = ", show(buy3), "\n",
  "  Produce Type I  (t)        = ", show(xI), "\n",
  "    A used in Type I (t)     = ", show(aI), "\n",
  "    A proportion Type I      = ", show(aI / max(1.0, xI)), "\n",
  "  Produce Type II (t)        = ", show(xII), "\n",
  "    A used in Type II (t)    = ", show(aII), "\n",
  "    A proportion Type II     = ", show(aII / max(1.0, xII)), "\n",
  "  Revenue (yuan)             = ", show(revenue), "\n",
  "  Purchase cost (yuan)       = ", show(costA), "\n",
  "  Profit (yuan)              = ", show(profit), "\n"
];