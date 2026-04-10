% Parameters
int: N = 3;
set of int: P = 1..N;

int: Days = 22;

array[P] of int: maxDemand = [5300, 4500, 5400];          % in units of 100kg
array[P] of int: price     = [124, 109, 115];            % $ per 100kg
array[P] of float: varCost = [73.30, 52.90, 65.40];      % $ per 100kg
array[P] of int: quota     = [500, 450, 550];            % max 100kg units/day if fully devoted

array[P] of int: actCost   = [170000, 150000, 100000];   % $
array[P] of int: minBatch  = [20, 20, 16];               % in units of 100kg

% A safe upper bound on total production per product (can never exceed demand, nor Days*quota)
array[P] of int: ubProd = [ min(maxDemand[p], Days*quota[p]) | p in P ];

% Variables
array[P] of var 0..max(ubProd): x;     % total produced of each product (100kg units)
array[P] of var bool: y;               % 1 if product line activated (produce > 0), else 0

% Constraints
constraint
  forall(p in P) (
    x[p] <= maxDemand[p]
  );

constraint
  forall(p in P) (
    x[p] <= Days * quota[p]
  );

% Activation and minimum batch constraints
constraint
  forall(p in P) (
    x[p] >= minBatch[p] * bool2int(y[p])
  );

constraint
  forall(p in P) (
    x[p] <= ubProd[p] * bool2int(y[p])
  );

% Objective
var float: profit =
  sum(p in P) ( (int2float(price[p]) - varCost[p]) * int2float(x[p]) )
  - sum(p in P) ( int2float(actCost[p]) * bool2int(y[p]) );

solve maximize profit;