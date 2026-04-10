int: nGoods = 5;
set of int: G = 1..nGoods;

int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;

array[G] of int: demand = [120, 90, 300, 90, 120];

int: scale = 100;
array[G] of int: w = [50, 100, 40, 60, 65];

int: cap = 60 * scale;
int: minLoad = 18 * scale;

int: minD_per_container = 12;

int: totalW = sum(g in G)(w[g] * demand[g]);
int: K = (totalW + minLoad - 1) div minLoad;
set of int: Kset = 1..K;

array[Kset] of var bool: used;
array[G, Kset] of var 0..max(demand): x;

constraint forall(g in G)(
  sum(k in Kset)(x[g,k]) = demand[g]
);

constraint forall(k in Kset)(
  sum(g in G)(w[g] * x[g,k]) <= cap
);

constraint forall(k in Kset)(
  sum(g in G)(w[g] * x[g,k]) >= minLoad * bool2int(used[k])
);

constraint forall(g in G, k in Kset)(
  x[g,k] <= demand[g] * bool2int(used[k])
);

constraint forall(k in Kset)(
  x[C,k] >= (x[A,k] + demand[A] - 1) div demand[A]
);

constraint forall(k in Kset)(
  x[D,k] >= minD_per_container * bool2int(used[k])
);

constraint forall(k in 1..K-1)(
  bool2int(used[k]) >= bool2int(used[k+1])
);

solve minimize sum(k in Kset)(bool2int(used[k]));