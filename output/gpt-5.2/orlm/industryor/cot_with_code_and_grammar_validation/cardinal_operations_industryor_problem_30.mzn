int: nProd = 3;
set of int: P = 1..nProd;

int: nA = 2;
set of int: A = 1..nA;

int: nB = 3;
set of int: B = 1..nB;

array[A, P] of int: tA = array2d(A, P,
  [ 5, 10,  0,
    7,  9, 12 ]
);

array[B, P] of int: tB = array2d(B, P,
  [ 6,  8,  0,
    4,  0, 11,
    7,  0,  0 ]
);

array[A] of int: capA = [6000, 10000];
array[B] of int: capB = [4000, 7000, 4000];

array[A] of float: costA = [0.05, 0.03];
array[B] of float: costB = [0.06, 0.11, 0.05];

array[P] of float: rawCost = [0.25, 0.35, 0.5];
array[P] of float: price = [1.25, 2.0, 2.8];

array[A, P] of var 0..100000: xA;
array[B, P] of var 0..100000: xB;

array[P] of var 0..100000: q;

var float: profit;

constraint forall(p in P) (
  q[p] = sum(a in A)(xA[a, p]) /\
  q[p] = sum(b in B)(xB[b, p])
);

constraint forall(a in A, p in P where tA[a, p] = 0) (xA[a, p] = 0);
constraint forall(b in B, p in P where tB[b, p] = 0) (xB[b, p] = 0);

constraint forall(a in A) (
  sum(p in P)(tA[a, p] * xA[a, p]) <= capA[a]
);

constraint forall(b in B) (
  sum(p in P)(tB[b, p] * xB[b, p]) <= capB[b]
);

constraint
  profit =
    sum(p in P)((price[p] - rawCost[p]) * int2float(q[p]))
    - sum(a in A)(costA[a] * int2float(sum(p in P)(tA[a, p] * xA[a, p])))
    - sum(b in B)(costB[b] * int2float(sum(p in P)(tB[b, p] * xB[b, p])));

solve maximize profit;

output [
  "profit = ", show(profit), "\n",
  "q = ", show(q), "\n",
  "xA = ", show(xA), "\n",
  "xB = ", show(xB), "\n"
];