int: P = 3;
set of int: PRODUCTS = 1..P;

int: MA = 2;
set of int: MACH_A = 1..MA;

int: MB = 3;
set of int: MACH_B = 1..MB;

array[MACH_A, PRODUCTS] of int: tA =
  array2d(MACH_A, PRODUCTS,
    [ 5, 10,  0,
      7,  9, 12
    ]);

array[MACH_B, PRODUCTS] of int: tB =
  array2d(MACH_B, PRODUCTS,
    [ 6,  8,  0,
      4,  0, 11,
      7,  0,  0
    ]);

array[MACH_A] of int: capA = [6000, 10000];
array[MACH_B] of int: capB = [4000, 7000, 4000];

array[MACH_A] of float: costFullA = [300.0, 321.0];
array[MACH_B] of float: costFullB = [250.0, 783.0, 200.0];

array[PRODUCTS] of float: rawCost = [0.25, 0.35, 0.50];
array[PRODUCTS] of float: price = [1.25, 2.00, 2.80];

array[PRODUCTS] of int: maxProd = [
  min(
    [ capA[a] div tA[a,1] | a in MACH_A where tA[a,1] > 0 ] ++
    [ capB[b] div tB[b,1] | b in MACH_B where tB[b,1] > 0 ]
  ),
  min(
    [ capA[a] div tA[a,2] | a in MACH_A where tA[a,2] > 0 ] ++
    [ capB[b] div tB[b,2] | b in MACH_B where tB[b,2] > 0 ]
  ),
  min(
    [ capA[a] div tA[a,3] | a in MACH_A where tA[a,3] > 0 ] ++
    [ capB[b] div tB[b,3] | b in MACH_B where tB[b,3] > 0 ]
  )
];

int: UB = max(maxProd);

array[PRODUCTS] of var 0..UB: x;
array[MACH_A, PRODUCTS] of var 0..UB: yA;
array[MACH_B, PRODUCTS] of var 0..UB: yB;

array[MACH_A] of var 0.0..1.0: uA;
array[MACH_B] of var 0.0..1.0: uB;

var float: profit;

constraint forall(a in MACH_A, p in PRODUCTS where tA[a,p] = 0) (yA[a,p] = 0);
constraint forall(b in MACH_B, p in PRODUCTS where tB[b,p] = 0) (yB[b,p] = 0);

constraint forall(p in PRODUCTS) (sum(a in MACH_A)(yA[a,p]) = x[p]);
constraint forall(p in PRODUCTS) (sum(b in MACH_B)(yB[b,p]) = x[p]);

constraint forall(a in MACH_A) (
  sum(p in PRODUCTS)(tA[a,p] * yA[a,p]) <= capA[a]
);
constraint forall(b in MACH_B) (
  sum(p in PRODUCTS)(tB[b,p] * yB[b,p]) <= capB[b]
);

constraint forall(a in MACH_A) (
  uA[a] = int2float(sum(p in PRODUCTS)(tA[a,p] * yA[a,p])) / int2float(capA[a])
);
constraint forall(b in MACH_B) (
  uB[b] = int2float(sum(p in PRODUCTS)(tB[b,p] * yB[b,p])) / int2float(capB[b])
);

constraint profit =
  sum(p in PRODUCTS)((price[p] - rawCost[p]) * int2float(x[p]))
  - sum(a in MACH_A)(costFullA[a] * uA[a])
  - sum(b in MACH_B)(costFullB[b] * uB[b]);

solve maximize profit;

output [
  "profit=", show(profit), "\n",
  "x=", show(x), "\n",
  "uA=", show(uA), "\n",
  "uB=", show(uB), "\n",
  "yA=", show(yA), "\n",
  "yB=", show(yB), "\n"
];