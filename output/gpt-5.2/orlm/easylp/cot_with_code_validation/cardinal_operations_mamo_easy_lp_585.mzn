% Marketing budget allocation - MiniZinc model (data embedded)

% Indices
int: n = 4;
set of int: CH = 1..n;

int: TV = 1;
int: Radio = 2;
int: Social = 3;
int: Outdoor = 4;

% Max allocations (units)
array[CH] of int: maxAlloc = [700, 600, 500, 400];

% Costs in cents-of-thousands to avoid floats:
% TV 0.50 -> 50, Radio 0.60 -> 60, Social 0.80 -> 80, Outdoor 1.20 -> 120
array[CH] of int: costCentsK = [50, 60, 80, 120];

% Decision variables (integer allocations)
array[CH] of var 0..700: x;

% Total cost in cents-of-thousands (upper bounded safely)
var 0..150000: totalCostCentsK;

% Constraints
constraint forall(c in CH)(x[c] <= maxAlloc[c]);

constraint x[TV] + x[Radio] >= 500;
constraint abs(x[Social] - x[Radio]) <= 200;
constraint x[Outdoor] >= x[TV] + 100;
constraint x[Social] + x[Outdoor] <= 800;

constraint totalCostCentsK = sum(c in CH)(costCentsK[c] * x[c]);

% Objective (minimization)
solve minimize totalCostCentsK;

% Optional output (includes rounded cost in thousands to 2 decimals)
output [
  "TV=", show(x[TV]), " Radio=", show(x[Radio]),
  " Social=", show(x[Social]), " Outdoor=", show(x[Outdoor]), "\n",
  "totalCostCentsK=", show(totalCostCentsK), "\n",
  "totalCostThousands=", show_float(fix(totalCostCentsK) / 100.0), "\n"
];