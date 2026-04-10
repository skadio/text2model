int: K;
int: H;

array[1..K, 1..K] of float: InputOne;
array[1..K] of float: ManpowerOne;

array[1..K, 1..K] of float: InputTwo;
array[1..K] of float: ManpowerTwo;

array[1..K] of float: Stock;
array[1..K] of float: Capacity;
float: ManpowerLimit;

set of int: I = 1..K;
set of int: Y = 0..H;
set of int: YY = 0..(H+2);

array[Y, I] of var float: prod;
array[Y, I] of var float: inv;
array[Y, I] of var float: stock;
array[YY, I] of var float: cap;

constraint forall(y in Y, i in I) (prod[y,i] >= 0.0);
constraint forall(y in Y, i in I) (inv[y,i] >= 0.0);
constraint forall(y in Y, i in I) (stock[y,i] >= 0.0);
constraint forall(y in YY, i in I) (cap[y,i] >= 0.0);

constraint forall(i in I) (cap[0,i] = Capacity[i]);
constraint forall(i in I) (stock[0,i] = Stock[i]);

constraint forall(i in I) (cap[1,i] = cap[0,i]);
constraint forall(y in 2..(H+2), i in I) (
  cap[y,i] = cap[y-1,i] + (if y-2 <= H then inv[y-2,i] else 0.0 endif)
);

constraint forall(y in 0..H, i in I) (prod[y,i] <= cap[y,i]);

constraint forall(y in 1..H, r in I) (
  stock[y-1,r] + prod[y-1,r]
  =
  sum(k in I) ((InputOne[r,k] + InputTwo[r,k]) * prod[y,k])
  + sum(i in I) ((InputOne[r,i] + InputTwo[r,i]) * inv[y,i])
  + stock[y,r]
);

constraint forall(y in 1..H) (
  sum(k in I) ((ManpowerOne[k] + ManpowerTwo[k]) * prod[y,k])
  + sum(i in I) ((ManpowerOne[i] + ManpowerTwo[i]) * inv[y,i])
  <= ManpowerLimit
);

constraint forall(i in I) (prod[H,i] = 0.0);

solve maximize sum(i in I) (prod[H-1,i] + prod[H-2,i]);