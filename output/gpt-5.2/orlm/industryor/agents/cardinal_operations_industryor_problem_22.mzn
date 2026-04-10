% Parameters
% Number of products
int: nProducts = 3;

% Product index set
set of int: PRODUCTS = 1..nProducts;

% Resource capacities (per week)
int: laborCapacity = 1500;
int: materialCapacity = 1600;

% Per-unit requirements and economics (indexed by product)
array[PRODUCTS] of int: laborPerUnit    = [3, 2, 6];
array[PRODUCTS] of int: materialPerUnit = [4, 3, 6];
array[PRODUCTS] of int: sellingPrice    = [120, 80, 180];
array[PRODUCTS] of int: variableCost    = [60, 40, 80];

% Weekly fixed costs for each product's special equipment
array[PRODUCTS] of int: fixedCost = [2000, 1500, 1000];

% Per-unit contribution margin (selling price - variable cost)
array[PRODUCTS] of int: unitProfit =
  [ sellingPrice[p] - variableCost[p] | p in PRODUCTS ];

% Big-M upper bounds from resource limits (max feasible qty if only product p is made)
array[PRODUCTS] of int: maxQtyByResources =
  [ min(laborCapacity div laborPerUnit[p], materialCapacity div materialPerUnit[p])
  | p in PRODUCTS
  ];


% Variables
% Production quantities (units produced per week) for each product (non-negative integers)
array[PRODUCTS] of var int: produceQty;

% Whether a product line/equipment is used this week (to incur fixed cost)
array[PRODUCTS] of var 0..1: useProduct;

% Total weekly profit
var int: totalProfit;


% Constraints
% --- Production domain / non-negativity ---
constraint forall(p in PRODUCTS) (
  produceQty[p] >= 0
);

% --- Activation (fixed-cost incurrence) via big-M linking ---
% If any quantity of product p is produced, then useProduct[p] must be 1.
constraint forall(p in PRODUCTS) (
  produceQty[p] <= maxQtyByResources[p] * useProduct[p]
);

% --- Weekly resource capacity constraints ---
constraint sum(p in PRODUCTS) (laborPerUnit[p] * produceQty[p]) <= laborCapacity;
constraint sum(p in PRODUCTS) (materialPerUnit[p] * produceQty[p]) <= materialCapacity;

% --- Profit accounting (contribution margins minus fixed costs) ---
constraint totalProfit =
  sum(p in PRODUCTS) (unitProfit[p] * produceQty[p]) -
  sum(p in PRODUCTS) (fixedCost[p] * useProduct[p]);

% --- Safe explicit upper bound on totalProfit (helps search/bounding) ---
constraint totalProfit <= sum(p in PRODUCTS) (unitProfit[p] * maxQtyByResources[p]);


% Objective
solve maximize totalProfit;