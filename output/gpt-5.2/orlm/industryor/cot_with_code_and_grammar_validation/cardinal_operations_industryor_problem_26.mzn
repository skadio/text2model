int: nP = 3;
int: nM = 5;

set of int: P = 1..nP;
set of int: M = 1..nM;

set of int: A = {1,2};
set of int: B = {3,4,5};

array[P] of float: price = [1.25, 2.00, 2.80];
array[P] of float: raw = [0.25, 0.35, 0.50];

array[M] of int: hours = [6000, 10000, 4000, 7000, 4000];
array[M] of float: full_cost = [300.0, 321.0, 250.0, 783.0, 200.0];

array[M,P] of int: t = array2d(M, P, [
  5, 10,  0,
  7,  9, 12,
  6,  8,  0,
  4,  0, 11,
  7,  0,  0
]);

array[M,P] of bool: allow = array2d(M, P, [
  true,  true,  false,
  true,  true,  true,
  true,  true,  false,
  true,  false, true,
  true,  false, false
]);

array[P] of var float: q;
array[M] of var float: u;
array[A,P] of var float: fracA;
array[B,P] of var float: fracB;

constraint forall(p in P) (q[p] >= 0.0);
constraint forall(m in M) (u[m] >= 0.0 /\ u[m] <= 1.0);
constraint forall(m in A, p in P) (fracA[m,p] >= 0.0 /\ fracA[m,p] <= 1.0);
constraint forall(m in B, p in P) (fracB[m,p] >= 0.0 /\ fracB[m,p] <= 1.0);

constraint forall(m in A, p in P) ((not allow[m,p]) -> (fracA[m,p] = 0.0));
constraint forall(m in B, p in P) ((not allow[m,p]) -> (fracB[m,p] = 0.0));

constraint forall(p in P) (sum(m in A)(fracA[m,p]) = 1.0);
constraint forall(p in P) (sum(m in B)(fracB[m,p]) = 1.0);

constraint forall(m in A)(
  sum(p in P)(int2float(t[m,p]) * q[p] * fracA[m,p]) <= int2float(hours[m]) * u[m]
);
constraint forall(m in B)(
  sum(p in P)(int2float(t[m,p]) * q[p] * fracB[m,p]) <= int2float(hours[m]) * u[m]
);

var float: profit =
    sum(p in P)((price[p] - raw[p]) * q[p])
  - sum(m in M)(full_cost[m] * u[m]);

solve maximize profit;

output [
  "profit=", show(profit), "\n",
  "q=", show(q), "\n",
  "u=", show(u), "\n",
  "fracA=\n",
  concat([ concat([ show(fracA[m,p]) ++ (if p==nP then "\n" else " " endif) | p in P]) | m in A]),
  "fracB=\n",
  concat([ concat([ show(fracB[m,p]) ++ (if p==nP then "\n" else " " endif) | p in P]) | m in B])
];