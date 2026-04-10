int: K;
int: I;

array[1..K, 1..I] of int: Requirement;

array[1..K] of int: Strength;
array[1..K] of float: LessOneWaste;
array[1..K] of float: MoreOneWaste;

array[1..K] of int: Recruit;

array[1..K] of int: CostRedundancy;

int: NumOverman;
array[1..K] of int: CostOverman;

int: NumShortwork;
array[1..K] of int: CostShort;

array[1..K, 0..I] of var 0..max(Strength): S;
array[1..K, 1..I] of var 0..max(Recruit): H;
array[1..K, 1..I] of var 0..max(Strength): R;
array[1..K, 1..I] of var 0..max(Strength): O;
array[1..K, 1..I] of var 0..max(Strength): SW;

array[1..K, 1..I] of var 0..2*max(Strength): eff2;

constraint forall(k in 1..K) (
  S[k,0] = Strength[k]
);

constraint forall(k in 1..K, t in 1..I) (
  H[k,t] <= Recruit[k]
);

constraint forall(k in 1..K, t in 1..I) (
  SW[k,t] <= NumShortwork
);

constraint forall(t in 1..I) (
  sum(k in 1..K)(SW[k,t]) <= NumShortwork
);

constraint forall(t in 1..I) (
  sum(k in 1..K)(O[k,t]) <= NumOverman
);

constraint forall(k in 1..K, t in 1..I) (
  R[k,t] + SW[k,t] <= S[k,t-1]
);

constraint forall(k in 1..K, t in 1..I) (
  eff2[k,t] = 2*(S[k,t-1] - R[k,t] - SW[k,t]) + SW[k,t]
);

constraint forall(k in 1..K, t in 1..I) (
  eff2[k,t] >= 2*Requirement[k,t]
);

constraint forall(k in 1..K, t in 1..I) (
  eff2[k,t] <= 2*(Requirement[k,t] + O[k,t])
);

constraint forall(k in 1..K, t in 1..I) (
  S[k,t] = round(
    (1.0 - MoreOneWaste[k]) * int2float(S[k,t-1] - R[k,t]) +
    (1.0 - LessOneWaste[k]) * int2float(H[k,t])
  )
);

solve minimize sum(k in 1..K, t in 1..I)(CostRedundancy[k] * R[k,t]);