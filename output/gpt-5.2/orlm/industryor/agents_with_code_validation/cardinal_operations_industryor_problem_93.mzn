% Blending and purchasing crude oil A/B to produce gasoline I/II
% Data embedded as per problem statement.

% Sets
int: nGas = 2;
set of int: GAS = 1..nGas;

% Data
array[GAS] of int: minPropPctA = [50, 60];      % percent to avoid floats
array[GAS] of int: sellPrice   = [4800, 5600];  % yuan/t

int: invA = 500;
int: invB = 1000;

int: maxPurchaseA = 1500;

int: nTiers = 3;
set of int: TIERS = 1..nTiers;
array[TIERS] of int: tierCapA   = [500, 500, 500];
array[TIERS] of int: tierPriceA = [10000, 8000, 6000];

% Decision variables (use integer tons for a MILP/CP-SAT style model)
array[GAS] of var 0..(invA + maxPurchaseA): useA;
array[GAS] of var 0..invB:                  useB;
array[GAS] of var 0..(invA + maxPurchaseA + invB): prod;

var 0..maxPurchaseA: purchaseA;
array[TIERS] of var 0..500: purchaseA_tier;  % each tier max 500

% Financials
var int: revenue;
var int: purchaseCost;
var int: profit;

% Constraints
constraint forall(g in GAS) (
  prod[g] = useA[g] + useB[g]
);

constraint sum(g in GAS)(useA[g]) <= invA + purchaseA;
constraint sum(g in GAS)(useB[g]) <= invB;

% Blend quality: useA/prod >= minProp  => 100*useA >= minPropPct * prod
constraint forall(g in GAS) (
  100 * useA[g] >= minPropPctA[g] * prod[g]
);

% Piecewise purchasing tiers
constraint purchaseA = sum(t in TIERS)(purchaseA_tier[t]);
constraint forall(t in TIERS) (purchaseA_tier[t] <= tierCapA[t]);

% Optional: enforce filling cheaper tiers after expensive tiers (given decreasing prices)
% This improves propagation and avoids symmetric solutions.
constraint purchaseA_tier[1] = min(tierCapA[1], purchaseA);
constraint purchaseA_tier[2] = min(tierCapA[2], max(0, purchaseA - tierCapA[1]));
constraint purchaseA_tier[3] = max(0, purchaseA - tierCapA[1] - tierCapA[2]);

% Revenue and cost
constraint revenue      = sum(g in GAS)(sellPrice[g] * prod[g]);
constraint purchaseCost = sum(t in TIERS)(tierPriceA[t] * purchaseA_tier[t]);
constraint profit       = revenue - purchaseCost;

% Objective type required: minimization.
% Minimize negative profit (equivalent to maximizing profit).
solve minimize -profit;

output [
  "purchaseA=", show(purchaseA), "\n",
  "purchaseA_tier=", show(purchaseA_tier), "\n",
  "useA=", show(useA), "\n",
  "useB=", show(useB), "\n",
  "prod=", show(prod), "\n",
  "revenue=", show(revenue), "\n",
  "purchaseCost=", show(purchaseCost), "\n",
  "profit=", show(profit), "\n"
];