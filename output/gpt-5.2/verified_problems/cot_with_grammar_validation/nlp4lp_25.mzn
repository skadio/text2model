int: K;
int: MaxWork;

array[1..K] of float: Royalty;
array[1..K] of float: Limit;
array[1..K] of float: Quality;

int: I;
array[1..I] of float: RequiredQuality;

float: Price;
float: Discount;

array[1..I, 1..K] of var float: x;
array[1..I, 1..K] of var bool: work;
array[1..I, 1..K] of var bool: open;

var float: profit;

constraint
  forall(i in 1..I, k in 1..K) (
    x[i,k] >= 0.0
  );

constraint
  forall(i in 1..I, k in 1..K) (
    x[i,k] <= Limit[k] * bool2int(work[i,k])
  );

constraint
  forall(i in 1..I) (
    sum(k in 1..K)(bool2int(work[i,k])) <= MaxWork
  );

constraint
  forall(i in 1..I, k in 1..K) (
    bool2int(work[i,k]) <= bool2int(open[i,k])
  );

constraint
  forall(i in 1..I-1, k in 1..K) (
    bool2int(open[i,k]) >= bool2int(open[i+1,k])
  );

constraint
  forall(i in 1..I) (
    sum(k in 1..K)(x[i,k] * Quality[k]) = RequiredQuality[i] * sum(k in 1..K)(x[i,k])
  );

constraint
  profit =
    sum(i in 1..I)(
      (1.0 / pow(1.0 + Discount, i - 1)) *
      ( Price * sum(k in 1..K)(x[i,k])
        - sum(k in 1..K)(Royalty[k] * bool2int(open[i,k]))
      )
    );

solve maximize profit;