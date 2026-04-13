% Factory production planning with bulk-discount (incremental) unit profits.
% Data embedded as per problem statement.

% Resource availability
int: prep_avail  = 100;
int: labor_avail = 700;
int: mat_avail   = 400;

% Resource use per unit for products A,B,C
array[1..3] of int: prep  = [1, 2, 1];
array[1..3] of int: labor = [10, 4, 5];
array[1..3] of int: mat   = [3, 2, 1];

% Safe upper bounds from resources
int: A_ub = min(prep_avail div prep[1], min(labor_avail div labor[1], mat_avail div mat[1])); % 70
int: B_ub = min(prep_avail div prep[2], min(labor_avail div labor[2], mat_avail div mat[2])); % 50
int: C_ub = min(prep_avail div prep[3], min(labor_avail div labor[3], mat_avail div mat[3])); % 100

% Decision variables: production quantities
var 0..A_ub: xA;
var 0..B_ub: xB;
var 0..C_ub: xC;

% Incremental segment variables (units sold in each bracket)
% A: 0..40 =>10; 41..100 =>9; 101..150 =>8; 151.. =>7
array[1..4] of int: A_cap = [40, 60, 50, A_ub];  % last cap effectively "rest", but bounded by A_ub
array[1..4] of int: A_p   = [10, 9, 8, 7];
array[1..4] of var 0..A_ub: yA;

% B: 0..50 =>6; 51..100 =>4; 101.. =>3 (but xB <= 50 here, so only first segment matters)
array[1..3] of int: B_cap = [50, 50, B_ub];
array[1..3] of int: B_p   = [6, 4, 3];
array[1..3] of var 0..B_ub: yB;

% C: 0..100 =>5; >100 =>4 (but xC <= 100 here, so only first segment matters)
array[1..2] of int: C_cap = [100, C_ub];
array[1..2] of int: C_p   = [5, 4];
array[1..2] of var 0..C_ub: yC;

% Profit
var int: profit;

% Resource constraints
constraint prep[1]*xA + prep[2]*xB + prep[3]*xC <= prep_avail;
constraint labor[1]*xA + labor[2]*xB + labor[3]*xC <= labor_avail;
constraint mat[1]*xA + mat[2]*xB + mat[3]*xC <= mat_avail;

% Link totals to segment allocations
constraint xA = sum(i in 1..4)(yA[i]);
constraint xB = sum(i in 1..3)(yB[i]);
constraint xC = sum(i in 1..2)(yC[i]);

% Capacity constraints per segment
constraint forall(i in 1..4)(yA[i] <= A_cap[i]);
constraint forall(i in 1..3)(yB[i] <= B_cap[i]);
constraint forall(i in 1..2)(yC[i] <= C_cap[i]);

% Enforce filling earlier segments before later segments (removes symmetry / speeds up)
constraint forall(i in 1..3)(yA[i] = A_cap[i] -> yA[i+1] >= 0);
constraint forall(i in 1..3)(yA[i+1] > 0 -> yA[i] = A_cap[i]);

constraint forall(i in 1..2)(yB[i+1] > 0 -> yB[i] = B_cap[i]);
constraint forall(i in 1..1)(yC[i+1] > 0 -> yC[i] = C_cap[i]);

% Profit definition
constraint profit =
    sum(i in 1..4)(A_p[i] * yA[i]) +
    sum(i in 1..3)(B_p[i] * yB[i]) +
    sum(i in 1..2)(C_p[i] * yC[i]);

solve maximize profit;

output [
  "xA=", show(xA), " xB=", show(xB), " xC=", show(xC), "\n",
  "profit=", show(profit), "\n",
  "yA=", show(yA), "\n",
  "yB=", show(yB), "\n",
  "yC=", show(yC), "\n"
];