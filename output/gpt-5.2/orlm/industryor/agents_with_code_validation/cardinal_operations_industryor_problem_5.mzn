% Contract reservations / production planning with inventory and backlogging

%----------------------------
% Sets and parameters
%----------------------------
int: nProducts = 3;                 % 1=I, 2=II, 3=III
set of int: PRODUCTS = 1..nProducts;

int: nQuarters = 4;
set of int: QUARTERS = 1..nQuarters;

% Demand[p,q] (units) by product and quarter
array[PRODUCTS, QUARTERS] of int: demand =
  array2d(PRODUCTS, QUARTERS,
    [ 1500, 1000, 2000, 1200,        % Product I
      1500, 1500, 1200, 1500,        % Product II
      1000, 2000, 1500, 2500 ]);     % Product III

int: initInventory = 0;             % initial inventory (each product)
int: finalInventoryReq = 150;       % required ending inventory after Q4 (each product)

int: hoursPerQuarter = 15000;
array[PRODUCTS] of int: hoursPerUnit = [2, 4, 3];  % I, II, III

int: invCost = 5;                   % per unit per quarter held at end of quarter
array[PRODUCTS] of int: delayPenalty = [20, 20, 10]; % per unit per quarter delayed (backlog at end)

% Production availability by product and quarter (I cannot be produced in Q2)
array[PRODUCTS, QUARTERS] of bool: canProduce =
  array2d(PRODUCTS, QUARTERS,
    [ true,  false, true,  true,     % Product I
      true,  true,  true,  true,     % Product II
      true,  true,  true,  true ]);  % Product III

% Safe upper bounds
int: maxTotalDemandAll = sum(p in PRODUCTS, q in QUARTERS)(demand[p,q]);
int: maxDemandPerQuarterAll = max([sum(p in PRODUCTS)(demand[p,q]) | q in QUARTERS]);
int: maxProdPerProductQuarter = maxDemandPerQuarterAll + finalInventoryReq;

%----------------------------
% Decision variables
%----------------------------
array[PRODUCTS, QUARTERS] of var 0..maxProdPerProductQuarter: prod;  % produced units
array[PRODUCTS, QUARTERS] of var 0..(maxTotalDemandAll + finalInventoryReq): inv;   % end inventory
array[PRODUCTS, QUARTERS] of var 0..(maxTotalDemandAll): back;       % end backlog
var 0..(10^9): totalCost;

%----------------------------
% Constraints
%----------------------------

% Enforce zero production if cannot produce
constraint forall(p in PRODUCTS, q in QUARTERS) (
  (not canProduce[p,q]) -> (prod[p,q] = 0)
);

% Quarterly capacity in hours
constraint forall(q in QUARTERS) (
  sum(p in PRODUCTS)(prod[p,q] * hoursPerUnit[p]) <= hoursPerQuarter
);

% Inventory/backlog balance:
% (inv - back)_end = (inv - back)_prev + production - demand
constraint forall(p in PRODUCTS, q in QUARTERS) (
  let {
    var int: invPrev  = if q = 1 then initInventory else inv[p,q-1] endif,
    var int: backPrev = if q = 1 then 0            else back[p,q-1] endif
  } in
    inv[p,q] - back[p,q] = invPrev - backPrev + prod[p,q] - demand[p,q]
);

% No simultaneous inventory and backlog (tightens model, optional but kept)
constraint forall(p in PRODUCTS, q in QUARTERS) (
  inv[p,q] * back[p,q] = 0
);

% Ending requirements
constraint forall(p in PRODUCTS) (
  inv[p,nQuarters] >= finalInventoryReq
);
constraint forall(p in PRODUCTS) (
  back[p,nQuarters] = 0
);

% Cost: inventory holding + delay penalties (per quarter, based on end-of-quarter levels)
constraint totalCost =
  sum(p in PRODUCTS, q in QUARTERS)(
    invCost * inv[p,q] + delayPenalty[p] * back[p,q]
  );

%----------------------------
% Objective
%----------------------------
solve minimize totalCost;