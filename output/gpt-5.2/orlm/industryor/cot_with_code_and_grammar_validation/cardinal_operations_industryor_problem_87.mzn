int: nProd = 2;
set of int: PROD = 1..nProd;

int: nMach = 2;
set of int: MACH = 1..nMach;

array[MACH, PROD] of int: timeMin =
  array2d(MACH, PROD, [
    50, 24,
    30, 33
  ]);

array[MACH] of int: availMin = [40*60, 35*60];

array[PROD] of float: initInv = [30.0, 90.0];
array[PROD] of float: demand  = [75.0, 95.0];

array[PROD] of var 0.0..1000000.0: prod;
array[PROD] of var float: endInv;

constraint forall(p in PROD) (
  endInv[p] = initInv[p] + prod[p] - demand[p]
);

constraint forall(m in MACH) (
  sum(p in PROD)(timeMin[m,p] * prod[p]) <= availMin[m]
);

solve maximize sum(p in PROD)(endInv[p]);