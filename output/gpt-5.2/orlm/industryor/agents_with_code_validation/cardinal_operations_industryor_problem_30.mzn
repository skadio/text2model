% Factory production planning (embedded data) - MAXIMIZE profit

%----------------------------
% Sets / indices
%----------------------------
enum PRODUCT = {I, II, III};
enum A_EQUIP = {A1, A2};
enum B_EQUIP = {B1, B2, B3};

%----------------------------
% Machine availability (effective machine hours)
%----------------------------
array[A_EQUIP] of int: availA = [6000, 10000];
array[B_EQUIP] of int: availB = [4000, 7000, 4000];

%----------------------------
% Processing cost per machine hour (Yuan/hour)
%----------------------------
array[A_EQUIP] of float: costA_per_hour = [0.05, 0.03];
array[B_EQUIP] of float: costB_per_hour = [0.06, 0.11, 0.05];

%----------------------------
% Processing time per piece on each equipment (hours/piece)
% Use 0.0 for infeasible combinations (and gate with allowed* arrays).
% IMPORTANT: use array2d to match the declared 2D array types.
%----------------------------
array[A_EQUIP, PRODUCT] of float: timeA =
  array2d(A_EQUIP, PRODUCT,
    [
      % A1: I, II, III
      5.0, 10.0, 0.0,
      % A2: I, II, III
      7.0,  9.0, 12.0
    ]);

array[B_EQUIP, PRODUCT] of float: timeB =
  array2d(B_EQUIP, PRODUCT,
    [
      % B1: I, II, III
      6.0,  8.0, 0.0,
      % B2: I, II, III
      4.0,  0.0, 11.0,
      % B3: I, II, III
      7.0,  0.0, 0.0
    ]);

%----------------------------
% Feasibility (routing rules): true = allowed, false = not allowed
%----------------------------
array[A_EQUIP, PRODUCT] of bool: allowedA =
  array2d(A_EQUIP, PRODUCT,
    [
      % A1: I, II, III
      true, true, false,
      % A2: I, II, III
      true, true, true
    ]);

array[B_EQUIP, PRODUCT] of bool: allowedB =
  array2d(B_EQUIP, PRODUCT,
    [
      % B1: I, II, III
      true,  true,  false,
      % B2: I, II, III
      true,  false, true,
      % B3: I, II, III
      true,  false, false
    ]);

%----------------------------
% Economics (Yuan/piece)
%----------------------------
array[PRODUCT] of float: raw_cost   = [0.25, 0.35, 0.5];
array[PRODUCT] of float: unit_price = [1.25, 2.0, 2.8];

%----------------------------
% Safe upper bound on producible quantity for each product
% (derived from available hours / minimum feasible processing time)
%----------------------------
array[PRODUCT] of int: max_qty =
[
  min( availA[A1] div 5,
       min(availA[A2] div 7,
           min(availB[B1] div 6,
               min(availB[B2] div 4, availB[B3] div 7))) ), % I
  min( availA[A1] div 10,
       min(availA[A2] div 9, availB[B1] div 8) ),          % II
  min( availA[A2] div 12, availB[B2] div 11 )              % III
];

int: MAXQ = max(max_qty);

%----------------------------
% Variables
%----------------------------
array[A_EQUIP, PRODUCT] of var 0..MAXQ: xA; % pieces routed to A equipment
array[B_EQUIP, PRODUCT] of var 0..MAXQ: xB; % pieces routed to B equipment
array[PRODUCT] of var 0..MAXQ: q;           % total produced
var float: total_profit;

%----------------------------
% Constraints
%----------------------------

% Routing feasibility (force forbidden equipment-product combinations to 0)
constraint forall(a in A_EQUIP, p in PRODUCT) (
  (not allowedA[a,p]) -> (xA[a,p] = 0)
);

constraint forall(b in B_EQUIP, p in PRODUCT) (
  (not allowedB[b,p]) -> (xB[b,p] = 0)
);

% Flow conservation: each produced unit must be processed once in stage A and once in stage B
constraint forall(p in PRODUCT) (
  q[p] = sum(a in A_EQUIP)(xA[a,p])
);

constraint forall(p in PRODUCT) (
  q[p] = sum(b in B_EQUIP)(xB[b,p])
);

% Machine capacity constraints (effective hours)
constraint forall(a in A_EQUIP) (
  sum(p in PRODUCT)(timeA[a,p] * int2float(xA[a,p])) <= int2float(availA[a])
);

constraint forall(b in B_EQUIP) (
  sum(p in PRODUCT)(timeB[b,p] * int2float(xB[b,p])) <= int2float(availB[b])
);

% Profit definition (revenue - raw material cost - processing costs)
constraint
  total_profit =
      sum(p in PRODUCT)(unit_price[p] * int2float(q[p]))
    - sum(p in PRODUCT)(raw_cost[p]   * int2float(q[p]))
    - sum(a in A_EQUIP, p in PRODUCT)(costA_per_hour[a] * timeA[a,p] * int2float(xA[a,p]))
    - sum(b in B_EQUIP, p in PRODUCT)(costB_per_hour[b] * timeB[b,p] * int2float(xB[b,p]));

%----------------------------
% Objective
%----------------------------
solve maximize total_profit;

%----------------------------
% Output
%----------------------------
output [
  "q = ", show(q), "\n",
  "xA = ", show(xA), "\n",
  "xB = ", show(xB), "\n",
  "total_profit = ", show(total_profit), "\n"
];