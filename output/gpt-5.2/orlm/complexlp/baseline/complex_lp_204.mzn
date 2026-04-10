% Fertilizer blending to meet target ranges at minimal cost
% Data embedded directly in this model.

int: n = 5;
set of int: F = 1..n;

% Percent contents (by weight) for each fertilizer
array[F] of float: Ni = [10.0, 8.0, 12.0, 10.0, 15.0];
array[F] of float: Ph = [8.0, 11.0, 7.0, 10.0, 10.0];
array[F] of float: Po = [12.0, 15.0, 12.0, 10.0, 6.0];

% Prices per 100 lb
array[F] of float: price_per_100lb = [21.75, 23.50, 22.00, 19.50, 18.50];

% Convert to cents per lb (integer for exact optimization)
array[F] of int: cost_cents_per_lb =
  [ round(price_per_100lb[i] * 100.0 / 100.0) | i in F ]; % dollars->cents, per 100lb -> per lb

% Target ranges (percent)
float: Ni_min = 10.0;  float: Ni_max = 10.5;
float: Ph_min = 8.0;   float: Ph_max = 8.5;
float: Po_min = 12.0;  float: Po_max = 12.5;

% Choose a 100 lb batch; variables are pounds of each fertilizer (integer lbs)
int: BATCH = 100;
array[F] of var 0..BATCH: x;  % lbs of each fertilizer

constraint sum(i in F)(x[i]) = BATCH;

% Composition constraints: weighted averages within required ranges.
% Multiply through by BATCH to avoid division.
constraint sum(i in F)(Ni[i] * int2float(x[i])) >= Ni_min * BATCH;
constraint sum(i in F)(Ni[i] * int2float(x[i])) <= Ni_max * BATCH;

constraint sum(i in F)(Ph[i] * int2float(x[i])) >= Ph_min * BATCH;
constraint sum(i in F)(Ph[i] * int2float(x[i])) <= Ph_max * BATCH;

constraint sum(i in F)(Po[i] * int2float(x[i])) >= Po_min * BATCH;
constraint sum(i in F)(Po[i] * int2float(x[i])) <= Po_max * BATCH;

% Total cost for 100 lb batch (in cents)
var int: total_cost_cents = sum(i in F)(cost_cents_per_lb[i] * x[i]);

solve minimize total_cost_cents;

output [
  "Batch size (lb): ", show(BATCH), "\n",
  "Amounts (lb): ", show(x), "\n",
  "Total cost for 100 lb (cents): ", show(total_cost_cents), "\n",
  "Cost per lb (cents): ", show(total_cost_cents div BATCH), "\n",
  "Cost per lb (dollars): ", show(int2float(total_cost_cents) / int2float(BATCH) / 100.0), "\n"
];