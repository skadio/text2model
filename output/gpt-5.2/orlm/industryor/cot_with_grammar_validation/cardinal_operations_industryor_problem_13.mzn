int: nP = 3;
set of int: P = 1..nP;

int: nV = 5;
set of int: V = 1..nV;

array[P] of int: protP = [23, 20, 8];
array[P] of int: costP_cents = [300, 500, 150];

array[V] of int: protV10 = [28, 9, 29, 10, 31];
array[V] of int: costV_cents = [120, 80, 150, 100, 200];

int: budget_cents = 2000;
int: maxWeight_g = 800;
int: packWeight_g = 100;

int: maxUnits = maxWeight_g div packWeight_g;

array[P] of var 0..maxUnits: xP;
array[V] of var 0..maxUnits: xV;
array[V] of var bool: useV;

var 0..(budget_cents * 31): totalProt10;
var 0..budget_cents: totalCost;
var 0..maxWeight_g: totalWeight;

constraint totalCost =
  sum(p in P)(costP_cents[p] * xP[p]) +
  sum(v in V)(costV_cents[v] * xV[v]);

constraint totalCost <= budget_cents;

constraint totalWeight =
  packWeight_g * (sum(p in P)(xP[p]) + sum(v in V)(xV[v]));

constraint totalWeight <= maxWeight_g;

constraint totalProt10 =
  10 * sum(p in P)(protP[p] * xP[p]) +
  sum(v in V)(protV10[v] * xV[v]);

constraint forall(v in V) (
  useV[v] <-> (xV[v] >= 1)
);

constraint sum(v in V)(bool2int(useV[v])) >= 3;

solve maximize totalProt10;