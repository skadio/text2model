% Parameters
int: nProducts = 3;
set of int: PRODUCTS = 1..nProducts;

int: nQuarters = 4;
set of int: QUARTERS = 1..nQuarters;

% Demand (contract reservations) per product per quarter
% Product 1=I, 2=II, 3=III
array[PRODUCTS, QUARTERS] of int: demand =
  array2d(PRODUCTS, QUARTERS,
    [ 1500, 1000, 2000, 1200,   % I
      1500, 1500, 1200, 1500,   % II
      1000, 2000, 1500, 2500 ]  % III
  );

% Initial inventory at start of quarter 1 (given as 0 for all)
array[PRODUCTS] of int: initInv = [0, 0, 0];

% Required ending inventory at end of quarter 4 (150 units each)
array[PRODUCTS] of int: finalInvReq = [150, 150, 150];

% Available production hours per quarter
int: hoursPerQuarter = 15000;

% Hours required per unit for each product (I, II, III)
array[PRODUCTS] of int: hoursPerUnit = [2, 4, 3];

% Per-unit per-quarter delay compensation (I, II: 20; III: 10)
array[PRODUCTS] of int: delayPenalty = [20, 20, 10];

% Inventory holding cost per unit per quarter
int: invCost = 5;

% Production feasibility: product I (1) cannot be produced in quarter 2
array[PRODUCTS, QUARTERS] of bool: canProduce =
  array2d(PRODUCTS, QUARTERS,
    [ true,  false, true,  true,   % I
      true,  true,  true,  true,   % II
      true,  true,  true,  true ]  % III
  );

% Useful bounds derived from data (for bounded variable declarations)
int: maxDemand = max([demand[p,q] | p in PRODUCTS, q in QUARTERS]);
int: totalDemandUpper =
  sum(p in PRODUCTS, q in QUARTERS)(demand[p,q]) + sum(p in PRODUCTS)(finalInvReq[p]);

% Variables
% Production quantity of product p in quarter q
array[PRODUCTS, QUARTERS] of var 0..totalDemandUpper: prod;

% Delivered quantity (on-time or late) of product p in quarter q
array[PRODUCTS, QUARTERS] of var 0..totalDemandUpper: ship;

% End-of-quarter inventory of product p after quarter q
array[PRODUCTS, QUARTERS] of var 0..totalDemandUpper: inv;

% Backlog (undelivered demand) carried at end of quarter q for product p
array[PRODUCTS, QUARTERS] of var 0..totalDemandUpper: backlog;

% Constraints

%-------------------------------
% Production capacity per quarter (hours limit)
%-------------------------------
constraint
  forall(q in QUARTERS)(
    sum(p in PRODUCTS)(hoursPerUnit[p] * prod[p,q]) <= hoursPerQuarter
  );

%-------------------------------
% Production feasibility (e.g., Product I cannot be produced in Q2)
%-------------------------------
constraint
  forall(p in PRODUCTS, q in QUARTERS where not canProduce[p,q])(
    prod[p,q] = 0
  );

%-------------------------------
% Shipping cannot exceed available supply in each quarter
% (available supply = previous inventory + current production)
%-------------------------------

% Quarter 1
constraint
  forall(p in PRODUCTS)(
    ship[p,1] <= initInv[p] + prod[p,1]
  );

% Quarters 2..4
constraint
  forall(p in PRODUCTS, q in 2..nQuarters)(
    ship[p,q] <= inv[p,q-1] + prod[p,q]
  );

%-------------------------------
% Shipping limited by demand due up to that quarter
% (cannot ship more than current demand plus any backlog entering quarter)
%-------------------------------

% Quarter 1: no initial backlog
constraint
  forall(p in PRODUCTS)(
    ship[p,1] <= demand[p,1]
  );

% Quarters 2..4: can ship current demand plus prior backlog
constraint
  forall(p in PRODUCTS, q in 2..nQuarters)(
    ship[p,q] <= demand[p,q] + backlog[p,q-1]
  );

%-------------------------------
% Backlog evolution definition via shipped quantities
% backlog_end = backlog_prev + demand - shipped
%-------------------------------

% Quarter 1
constraint
  forall(p in PRODUCTS)(
    backlog[p,1] = demand[p,1] - ship[p,1]
  );

% Quarters 2..4
constraint
  forall(p in PRODUCTS, q in 2..nQuarters)(
    backlog[p,q] = backlog[p,q-1] + demand[p,q] - ship[p,q]
  );

%-------------------------------
% Inventory evolution definition via shipped quantities
% inv_end = inv_prev + production - shipped
%-------------------------------

% Quarter 1
constraint
  forall(p in PRODUCTS)(
    inv[p,1] = initInv[p] + prod[p,1] - ship[p,1]
  );

% Quarters 2..4
constraint
  forall(p in PRODUCTS, q in 2..nQuarters)(
    inv[p,q] = inv[p,q-1] + prod[p,q] - ship[p,q]
  );

%-------------------------------
% Final inventory requirement at end of quarter 4
%-------------------------------
constraint
  forall(p in PRODUCTS)(
    inv[p,nQuarters] >= finalInvReq[p]
  );

%-------------------------------
% All demand must be satisfied by end of quarter 4 (no remaining backlog)
%-------------------------------
constraint
  forall(p in PRODUCTS)(
    backlog[p,nQuarters] = 0
  );

%-------------------------------
% Non-simultaneous inventory and backlog (avoid both positive at same time)
% This tightens the model: after each quarter, either you have stock or unmet demand.
%-------------------------------
constraint
  forall(p in PRODUCTS, q in QUARTERS)(
    inv[p,q] * backlog[p,q] = 0
  );

% Objective
solve minimize
  sum(p in PRODUCTS, q in QUARTERS)(
      invCost * inv[p,q]
    + delayPenalty[p] * backlog[p,q]
  );