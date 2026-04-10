int: nProd = 2;
set of int: PROD = 1..nProd;
int: LIQ = 1;
int: SOL = 2;

int: nMach = 2;
set of int: MACH = 1..nMach;
int: M1 = 1;
int: M2 = 2;

array[MACH, PROD] of int: time_min = array2d(MACH, PROD,
  [ 50, 24,
    30, 33
  ]
);

array[PROD] of float: init_inv = [30.0, 90.0];
array[PROD] of float: demand   = [75.0, 95.0];

array[MACH] of float: avail_min = [40.0*60.0, 35.0*60.0];

array[PROD] of var float: x;
array[PROD] of var float: end_inv;

constraint forall(p in PROD) (x[p] >= 0.0);
constraint forall(p in PROD) (end_inv[p] >= 0.0);

constraint forall(m in MACH) (
  sum(p in PROD)( time_min[m,p] * x[p] ) <= avail_min[m]
);

constraint forall(p in PROD) (
  end_inv[p] = init_inv[p] + x[p] - demand[p]
);

solve maximize sum(p in PROD)(end_inv[p]);