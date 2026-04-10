int: K;

array[1..K] of float: ManpowerOne;
array[1..K] of float: ManpowerTwo;

array[1..K] of float: Stock;
array[1..K] of float: Capacity;

array[1..K] of float: Demand;

array[1..K, 1..K] of float: InputOne;
array[1..K, 1..K] of float: InputTwo;

array[0..K] of var float: prod;
array[0..K] of var float: stockEnd;
array[0..K] of var float: capAvail;

array[0..K] of var float: opLevel;
array[0..K] of var float: invLevel;

constraint forall(t in 0..K) (
  prod[t] >= 0.0 /\ stockEnd[t] >= 0.0 /\ capAvail[t] >= 0.0 /\ opLevel[t] >= 0.0 /\ invLevel[t] >= 0.0
);

constraint stockEnd[0] = Stock[1];
constraint capAvail[0] = Capacity[1];

constraint forall(t in 0..K) (
  prod[t] <= capAvail[t]
);

constraint forall(t in 1..K) (
  stockEnd[t] = stockEnd[t-1] + prod[t] - Demand[t]
);

constraint forall(t in 1..K) (
  forall(i in 1..K) (
    (sum(j in 1..K) (InputOne[i,j])) * opLevel[t]
    + (sum(j in 1..K) (InputTwo[i,j])) * invLevel[t]
    <= stockEnd[t-1] + prod[t]
  )
);

constraint forall(t in 0..K) (
  prod[t] = opLevel[t]
);

constraint forall(t in 0..K) (
  capAvail[t] = Capacity[1] + sum(u in 0..K where u <= t - 2) (invLevel[u])
);

solve maximize
  sum(t in 1..K) (ManpowerOne[t] * opLevel[t] + ManpowerTwo[t] * invLevel[t]);