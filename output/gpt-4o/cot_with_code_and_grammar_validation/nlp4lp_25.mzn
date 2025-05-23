int: K;
int: MaxWork;

array[1..K] of float: Royalty;
array[1..K] of float: Limit;
array[1..K] of float: Quality;

array[int] of float: RequiredQuality;

float: Price;
float: Discount;

set of int: Years = index_set(RequiredQuality);
int: T = card(Years);

array[Years] of float: DF = [1.0 / pow(1.0 + Discount, t - 1) | t in Years];

array[Years, 1..K] of var 0..1: Operate;
array[Years, 1..K] of var 0.0..: Production;

constraint
  forall(t in Years, k in 1..K)(
    Production[t,k] <= Limit[k] * int2float(Operate[t,k])
  );

constraint
  forall(t in Years)(
    sum(k in 1..K)(Operate[t,k]) <= MaxWork
  );

constraint
  forall(t in Years)(
    sum(k in 1..K)(Quality[k] * Production[t,k]) =
    RequiredQuality[t] * sum(k in 1..K)(Production[t,k])
  );

solve maximize
  sum(t in Years)(
    DF[t] * (
      Price * sum(k in 1..K)(Production[t,k]) -
      sum(k in 1..K)(Royalty[k] * int2float(Operate[t,k]))
    )
  );