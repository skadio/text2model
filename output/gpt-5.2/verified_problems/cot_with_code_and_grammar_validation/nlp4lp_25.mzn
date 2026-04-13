int: K;
int: MaxWork;

array[1..K] of float: Royalty;
array[1..K] of float: Limit;
array[1..K] of float: Quality;

int: I;
array[1..I] of float: RequiredQuality;

float: Price;
float: Discount;

array[1..I, 1..K] of var bool: work;
array[1..I, 1..K] of var bool: open;
array[1..I, 1..K] of var float: prod;
array[1..I] of var float: totalProd;

constraint
  forall(i in 1..I, k in 1..K) (
    work[i,k] -> open[i,k]
  );

constraint
  forall(i in 1..I, k in 1..K) (
    prod[i,k] >= 0.0 /\
    prod[i,k] <= Limit[k] * bool2int(work[i,k])
  );

constraint
  forall(i in 1..I) (
    sum(k in 1..K)(bool2int(work[i,k])) <= MaxWork
  );

constraint
  forall(i in 1..I) (
    totalProd[i] = sum(k in 1..K)(prod[i,k])
  );

constraint
  forall(i in 1..I) (
    totalProd[i] >= 0.0 /\
    totalProd[i] <= sum(k in 1..K)(Limit[k])
  );

constraint
  forall(i in 2..I, k in 1..K) (
    bool2int(open[i,k]) <= bool2int(open[i-1,k])
  );

constraint
  forall(i in 2..I, k in 1..K) (
    open[i,k] -> exists(j in 1..i-1)(work[j,k])
  );

constraint
  forall(i in 1..I) (
    sum(k in 1..K)(Quality[k] * prod[i,k]) = RequiredQuality[i] * totalProd[i]
  );

solve maximize
  sum(i in 1..I)(
    (Price * totalProd[i] - sum(k in 1..K)(Royalty[k] * bool2int(open[i,k])))
    / pow(1.0 + Discount, i - 1)
  );