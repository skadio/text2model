% Production planning with activation costs and minimum batch sizes
% Data embedded as per problem statement

int: D = 22;                      % production days
int: P = 3;                       % number of products
set of int: PROD = 1..P;

array[PROD] of int: maxDemand      = [5300, 4500, 5400];     % units of 100kg
array[PROD] of int: price          = [124, 109, 115];        % $ per 100kg
array[PROD] of float: prodCost     = [73.30, 52.90, 65.40];  % $ per 100kg
array[PROD] of int: quotaPerDay    = [500, 450, 550];        % units of 100kg per day
array[PROD] of int: activationCost = [170000, 150000, 100000]; % $
array[PROD] of int: minBatch       = [20, 20, 16];           % units of 100kg

% Convert to cents and keep everything integer/linear
array[PROD] of int: priceCents = [ price[p] * 100 | p in PROD ];
array[PROD] of int: costCents  = [ round(prodCost[p] * 100.0) | p in PROD ];
array[PROD] of int: unitProfitCents = [ priceCents[p] - costCents[p] | p in PROD ];

% Variables
array[PROD] of var 0..max(maxDemand): x;   % total production (100kg units)
array[PROD] of var bool: y;                % 1 if product is activated

% Constraints
constraint forall(p in PROD) (
  x[p] <= maxDemand[p]
);

constraint forall(p in PROD) (
  x[p] <= D * quotaPerDay[p]
);

constraint forall(p in PROD) (
  x[p] >= minBatch[p] * bool2int(y[p])
);

constraint forall(p in PROD) (
  x[p] <= maxDemand[p] * bool2int(y[p])
);

% Objective (maximize profit in cents)
var int: totalProfitCents =
  sum(p in PROD)( unitProfitCents[p] * x[p] )
  - sum(p in PROD)( activationCost[p] * 100 * bool2int(y[p]) );

solve maximize totalProfitCents;

output [
  "x (100kg units) = ", show(x), "\n",
  "activated y     = ", show(y), "\n",
  "total profit $  = ", show(totalProfitCents div 100), ".", show(totalProfitCents mod 100), "\n"
];