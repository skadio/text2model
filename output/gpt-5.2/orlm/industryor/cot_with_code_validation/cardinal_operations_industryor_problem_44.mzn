% Parameters
int: prod = 3;
set of int: P = 1..prod;

int: A = 1;
int: B = 2;
int: C = 3;

array[P] of int: tech_req = [1, 2, 1];
array[P] of int: labor_req = [10, 4, 5];
array[P] of int: mat_req  = [3, 2, 1];

int: tech_avail = 100;
int: labor_avail = 700;
int: mat_avail = 400;

% Piecewise (volume -> unit profit) tiers per product.
% Model as selecting exactly one tier per product and bounding production by that tier range.
int: max_tiers = 4;
set of int: T = 1..max_tiers;

array[P] of int: num_tiers = [4, 3, 2];

% Lower/upper bounds for each tier (inclusive). Use a large upper bound for "Above".
int: BIG = 1000000;

array[P,T] of int: tier_lo = 
  [|  0,  41, 101, 151   % A
   |  0,  51, 101,   0   % B (tier 4 unused)
   |  0, 101,   0,   0   % C (tier 3-4 unused)
  |];

array[P,T] of int: tier_hi =
  [| 40, 100, 150, BIG   % A
   | 50, 100, BIG,   0   % B (tier 4 unused)
   |100, BIG,   0,   0   % C (tier 3-4 unused)
  |];

array[P,T] of int: tier_profit =
  [| 10,  9,  8,  7      % A
   |  6,  4,  3,  0      % B (tier 4 unused)
   |  5,  4,  0,  0      % C (tier 3-4 unused)
  |];

% Variables
array[P] of var 0..BIG: x;                 % production quantities
array[P,T] of var 0..1: y;                 % tier selection binaries

var 0..( (BIG*10) + (BIG*6) + (BIG*5) ): total_profit;

% Constraints
constraint
  sum(p in P)(tech_req[p] * x[p]) <= tech_avail;

constraint
  sum(p in P)(labor_req[p] * x[p]) <= labor_avail;

constraint
  sum(p in P)(mat_req[p] * x[p]) <= mat_avail;

% Exactly one valid tier per product; force unused tiers to 0
constraint
  forall(p in P)(
    sum(t in T)(y[p,t]) = 1 /\
    forall(t in T where t > num_tiers[p])(y[p,t] = 0)
  );

% Link production quantity to chosen tier bounds
constraint
  forall(p in P)(
    x[p] >= sum(t in T)(tier_lo[p,t] * y[p,t]) /\
    x[p] <= sum(t in T)(tier_hi[p,t] * y[p,t])
  );

% Define total profit (unit profit depends on chosen tier)
constraint
  total_profit =
    sum(p in P, t in T)(tier_profit[p,t] * x[p] * y[p,t]);

% Objective
solve maximize total_profit;