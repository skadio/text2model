% Parameters
int: nProducts = 3;                          % number of products
set of int: PRODUCTS = 1..nProducts;         % product index set

int: nDays = 22;                             % production days in the month

array[PRODUCTS] of int: maxDemand = [5300, 4500, 5400];            % maximum demand (units of 100kg)
array[PRODUCTS] of int: sellPrice = [124, 109, 115];               % selling price ($ per 100kg)
array[PRODUCTS] of float: prodCost = [73.30, 52.90, 65.40];        % production cost ($ per 100kg)
array[PRODUCTS] of int: dailyQuota = [500, 450, 550];              % max units/day if fully devoted (100kg units)

array[PRODUCTS] of int: activationCost = [170000, 150000, 100000]; % fixed activation cost ($)
array[PRODUCTS] of int: minBatch = [20, 20, 16];                   % minimum production batch (100kg units)

% Scale to integer cents to avoid float arithmetic in the objective
int: moneyScale = 100; % cents per dollar
array[PRODUCTS] of int: sellPriceC = [sellPrice[i] * moneyScale | i in PRODUCTS];
array[PRODUCTS] of int: prodCostC  = [round(prodCost[i] * moneyScale) | i in PRODUCTS];
array[PRODUCTS] of int: marginC    = [sellPriceC[i] - prodCostC[i] | i in PRODUCTS]; % cents per 100kg unit

% Variables
array[PRODUCTS] of var 0..1: activate;         % 1 if product line is activated for product i this month
array[PRODUCTS] of var 0..5400: produce;       % total production quantity for product i (100kg units)

% Constraints
% Basic bounds: demand and per-month capacity for each product (if run exclusively)
constraint forall(i in PRODUCTS) (
  produce[i] <= maxDemand[i] /\
  produce[i] <= nDays * dailyQuota[i]
);

% Fixed-charge / minimum batch logic:
% - if activate[i] = 0 then produce[i] = 0 (via upper bound)
% - if activate[i] = 1 then produce[i] >= minBatch[i]
constraint forall(i in PRODUCTS) (
  produce[i] >= minBatch[i] * activate[i]
);
constraint forall(i in PRODUCTS) (
  produce[i] <= maxDemand[i] * activate[i]
);

% Shared monthly capacity across products (in "day-equivalents"):
% Sum_i produce[i] / dailyQuota[i] <= nDays
% Implemented without division by cross-multiplying:
% Let Q = product of daily quotas, then:
% Sum_i produce[i] * (Q / dailyQuota[i]) <= nDays * Q
int: Q = product(i in PRODUCTS)(dailyQuota[i]);
array[PRODUCTS] of int: Qdiv = [Q div dailyQuota[i] | i in PRODUCTS];

constraint
  sum(i in PRODUCTS)( produce[i] * Qdiv[i] ) <= nDays * Q;

% Objective
% Maximize profit = sum_i (margin * units) - sum_i activationCost
% All in cents (integer objective)
solve maximize
  sum(i in PRODUCTS)(
    marginC[i] * produce[i] - activationCost[i] * moneyScale * activate[i]
  );