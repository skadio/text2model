% Parameters
%-----------------------------
% Resource availability
%-----------------------------
int: prep_avail = 100;      % total technical preparation hours available
int: labor_avail = 700;     % total direct labor hours available
int: material_avail = 400;  % total material (kg) available

%-----------------------------
% Products and per-unit requirements
%-----------------------------
int: nProd = 3;
set of int: PROD = 1..nProd;

array[PROD] of int: prep_req     = [1, 2, 1];   % hours/unit for A,B,C
array[PROD] of int: labor_req    = [10, 4, 5];  % hours/unit for A,B,C
array[PROD] of int: material_req = [3, 2, 1];   % kg/unit for A,B,C

%-----------------------------
% Piecewise (bulk discount) per-unit profit data
%-----------------------------
int: maxK = 4;
set of int: K = 1..maxK;

array[PROD] of int: Kp = [4, 3, 2];  % valid segments per product (A,B,C)

% Big-M used for "+infinity" segment upper bounds and linking constraints
int: bigM = 1000;

% Segment lower bounds (inclusive) and upper bounds (exclusive; modeled via <= ub-1)
array[PROD, K] of int: seg_lb = array2d(PROD, K, [
  0,  40, 100, 150,    % A
  0,  50, 100,   0,    % B (pad last)
  0, 100,   0,   0     % C (pad last two)
]);

array[PROD, K] of int: seg_ub = array2d(PROD, K, [
   40, 100, 150, bigM, % A
   50, 100, bigM,   0, % B (pad last)
  100, bigM,   0,   0  % C (pad last two)
]);

array[PROD, K] of int: seg_profit = array2d(PROD, K, [
  10, 9, 8, 7,         % A
   6, 4, 3, 0,         % B (pad last)
   5, 4, 0, 0          % C (pad last two)
]);

% Variables
%-----------------------------
% Production quantities (pieces) for each product
% q[1]=A, q[2]=B, q[3]=C
%-----------------------------
array[PROD] of var 0..bigM: q;

% Segment-selection binaries: choose exactly one valid segment per product
array[PROD, K] of var 0..1: use_seg;

% Effective per-unit profit for each product (determined by selected segment)
array[PROD] of var 0..10: unit_profit;

% Total profit
var 0..(10 * bigM * nProd): total_profit;

% Constraints
%-----------------------------
% Resource capacity constraints
%-----------------------------
constraint
  sum(p in PROD)(prep_req[p] * q[p]) <= prep_avail;

constraint
  sum(p in PROD)(labor_req[p] * q[p]) <= labor_avail;

constraint
  sum(p in PROD)(material_req[p] * q[p]) <= material_avail;

%-----------------------------
% Segment validity and selection constraints
%-----------------------------
constraint
  forall(p in PROD) (
    sum(k in 1..Kp[p])(use_seg[p,k]) = 1
  );

constraint
  forall(p in PROD) (
    forall(k in (Kp[p]+1)..maxK)(use_seg[p,k] = 0)
  );

%-----------------------------
% Link chosen segment to quantity bounds q[p]
% If segment k is chosen then q[p] must satisfy:
%   seg_lb[p,k] <= q[p] <= seg_ub[p,k]-1   (integer quantities, ub is exclusive)
%-----------------------------
constraint
  forall(p in PROD, k in 1..Kp[p]) (
    q[p] >= seg_lb[p,k] * use_seg[p,k]
  );

constraint
  forall(p in PROD, k in 1..Kp[p]) (
    q[p] <= (seg_ub[p,k] - 1) + bigM * (1 - use_seg[p,k])
  );

%-----------------------------
% Define unit_profit via chosen segment
%-----------------------------
constraint
  forall(p in PROD) (
    unit_profit[p] = sum(k in 1..Kp[p])(seg_profit[p,k] * use_seg[p,k])
  );

%-----------------------------
% Total profit computation
%-----------------------------
constraint
  total_profit = sum(p in PROD)(q[p] * unit_profit[p]);

% Objective
solve maximize total_profit;