int: N_orders = 3;
set of int: ORD = 1..N_orders;

array[ORD] of int: req_w = [5, 7, 9];
array[ORD] of int: req_len = [1000, 3000, 2000];

int: N_stock = 2;
set of int: STOCK = 1..N_stock;
array[STOCK] of int: stock_w = [10, 20];

int: n1_max_1 = 2;
int: n2_max_1 = 1;
int: n3_max_1 = 1;

array[0..n1_max_1, 0..n2_max_1, 0..n3_max_1] of bool: feas1 =
  array3d(0..n1_max_1, 0..n2_max_1, 0..n3_max_1,
    [ 5*n1 + 7*n2 + 9*n3 <= 10
    | n1 in 0..n1_max_1, n2 in 0..n2_max_1, n3 in 0..n3_max_1 ]
  );

int: P1 =
  sum(n1 in 0..n1_max_1, n2 in 0..n2_max_1, n3 in 0..n3_max_1)(
    if feas1[n1,n2,n3] then 1 else 0 endif
  );
set of int: PAT1 = 1..P1;

array[PAT1, ORD] of int: pat1_cnt =
  array2d(PAT1, ORD,
    [ v
    | n1 in 0..n1_max_1, n2 in 0..n2_max_1, n3 in 0..n3_max_1
      where feas1[n1,n2,n3],
      v in [n1, n2, n3]
    ]
  );

array[PAT1] of int: pat1_used_w =
  [ sum(o in ORD)( req_w[o] * pat1_cnt[p,o] ) | p in PAT1 ];

array[PAT1] of int: pat1_waste_w =
  [ stock_w[1] - pat1_used_w[p] | p in PAT1 ];

int: n1_max_2 = 4;
int: n2_max_2 = 2;
int: n3_max_2 = 2;

array[0..n1_max_2, 0..n2_max_2, 0..n3_max_2] of bool: feas2 =
  array3d(0..n1_max_2, 0..n2_max_2, 0..n3_max_2,
    [ 5*n1 + 7*n2 + 9*n3 <= 20
    | n1 in 0..n1_max_2, n2 in 0..n2_max_2, n3 in 0..n3_max_2 ]
  );

int: P2 =
  sum(n1 in 0..n1_max_2, n2 in 0..n2_max_2, n3 in 0..n3_max_2)(
    if feas2[n1,n2,n3] then 1 else 0 endif
  );
set of int: PAT2 = 1..P2;

array[PAT2, ORD] of int: pat2_cnt =
  array2d(PAT2, ORD,
    [ v
    | n1 in 0..n1_max_2, n2 in 0..n2_max_2, n3 in 0..n3_max_2
      where feas2[n1,n2,n3],
      v in [n1, n2, n3]
    ]
  );

array[PAT2] of int: pat2_used_w =
  [ sum(o in ORD)( req_w[o] * pat2_cnt[p,o] ) | p in PAT2 ];

array[PAT2] of int: pat2_waste_w =
  [ stock_w[2] - pat2_used_w[p] | p in PAT2 ];

array[PAT1] of var float: x1;
array[PAT2] of var float: x2;

constraint forall(p in PAT1)(x1[p] >= 0.0);
constraint forall(p in PAT2)(x2[p] >= 0.0);

constraint forall(o in ORD)(
  sum(p in PAT1)( int2float(pat1_cnt[p,o]) * x1[p] ) +
  sum(p in PAT2)( int2float(pat2_cnt[p,o]) * x2[p] )
  >= int2float(req_len[o])
);

var float: total_waste_area =
  sum(p in PAT1)( (int2float(pat1_waste_w[p]) / 10.0) * x1[p] ) +
  sum(p in PAT2)( (int2float(pat2_waste_w[p]) / 10.0) * x2[p] );

solve minimize total_waste_area;

output [
  "Total waste area (m^2) = ", show(total_waste_area), "\n",
  "Patterns for stock width 1.0m:\n",
  concat([ "  p=" ++ show(p) ++ " cnt=" ++ show([pat1_cnt[p,o] | o in ORD]) ++
           " waste_w=" ++ show(int2float(pat1_waste_w[p]) / 10.0) ++
           " x=" ++ show(x1[p]) ++ "\n"
         | p in PAT1 ]),
  "Patterns for stock width 2.0m:\n",
  concat([ "  p=" ++ show(p) ++ " cnt=" ++ show([pat2_cnt[p,o] | o in ORD]) ++
           " waste_w=" ++ show(int2float(pat2_waste_w[p]) / 10.0) ++
           " x=" ++ show(x2[p]) ++ "\n"
         | p in PAT2 ])
];