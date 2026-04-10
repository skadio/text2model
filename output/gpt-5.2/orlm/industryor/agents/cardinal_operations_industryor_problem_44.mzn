% Parameters
% Products: 1=A, 2=B, 3=C
int: nProducts = 3;
set of int: PRODUCTS = 1..nProducts;

% Resource types: 1=technical prep, 2=labor, 3=materials
int: nResources = 3;
set of int: RESOURCES = 1..nResources;

% Resource consumption per unit of product (rows=resources, cols=products)
array[RESOURCES, PRODUCTS] of int: req =
  array2d(RESOURCES, PRODUCTS,
    [ 1,  2,  1,   % technical prep hours for A,B,C
     10,  4,  5,   % labor hours for A,B,C
      3,  2,  1    % materials kg for A,B,C
    ]);

% Available resources (technical prep, labor, materials)
array[RESOURCES] of int: cap = [100, 700, 400];

% Discount/profit tiers per product (piecewise constant per-unit profit)
int: maxTiers = 4;
set of int: TIERS = 1..maxTiers;

% Number of active tiers for each product
array[PRODUCTS] of int: nTiers = [4, 3, 2];

% Upper bound (capacity) of each tier (pieces). A large number is used for "Above ..."
int: BIG = 1000000;

% Tier capacities for each product (how many units can be produced within that tier)
% A: [0-40]=40, (40-100]=60, (100-150]=50, >150=BIG
% B: [0-50]=50, (50-100]=50, >100=BIG, unused
% C: [0-100]=100, >100=BIG, unused, unused
array[PRODUCTS, TIERS] of int: tierCap =
  array2d(PRODUCTS, TIERS,
    [ 40,  60,  50,  BIG,   % A
      50,  50,  BIG,   0,   % B
     100, BIG,   0,   0     % C
    ]);

% Per-unit profit (yuan) in each tier
array[PRODUCTS, TIERS] of int: tierProfit =
  array2d(PRODUCTS, TIERS,
    [ 10,  9,  8,  7,    % A
       6,  4,  3,  0,    % B
       5,  4,  0,  0     % C
    ]);

% Practical upper bound on total production per product derived from resources
array[PRODUCTS] of int: maxProd =
  [ min([ cap[1] div req[1,1], cap[2] div req[2,1], cap[3] div req[3,1] ]),
    min([ cap[1] div req[1,2], cap[2] div req[2,2], cap[3] div req[3,2] ]),
    min([ cap[1] div req[1,3], cap[2] div req[2,3], cap[3] div req[3,3] ])
  ];

% Variables
% Units produced in each tier for each product
array[PRODUCTS, TIERS] of var 0..BIG: xTier;

% Total units produced of each product
array[PRODUCTS] of var int: x;

% Total profit to maximize
var int: totalProfit;

% Constraints
% --- Tier activation / bounds ---
% Ensures only active tiers can take value, and they are within their tier capacity.
constraint
  forall(p in PRODUCTS, t in TIERS) (
    (t <= nTiers[p] /\ tierCap[p,t] > 0) ->
      (xTier[p,t] <= tierCap[p,t])
    else
      xTier[p,t] = 0
  );

% --- Link total production to tier quantities + overall bounds ---
constraint
  forall(p in PRODUCTS) (
    x[p] = sum(t in TIERS)(xTier[p,t]) /\
    0 <= x[p] /\ x[p] <= maxProd[p]
  );

% --- Resource capacity constraints ---
% Respect technical preparation, labor, and material availability.
constraint
  forall(r in RESOURCES) (
    sum(p in PRODUCTS)(req[r,p] * x[p]) <= cap[r]
  );

% --- Profit definition ---
constraint
  totalProfit = sum(p in PRODUCTS, t in TIERS)(tierProfit[p,t] * xTier[p,t]);

% Objective
solve maximize totalProfit;