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

int: MaxWork = max(Strength) + I * max(Recruit);

array[1..K, 1..I] of var 0..MaxWork: Work;
array[1..K, 1..I] of var 0..max(Recruit): Hire;
array[1..K, 1..I] of var 0..MaxWork: Red;
array[1..K, 1..I] of var 0..MaxWork: Short;
array[1..K, 1..I] of var 0..MaxWork: Over;

constraint forall(k in 1..K)(Work[k,1] = Strength[k]);

constraint forall(k in 1..K, y in 1..I)(
  Hire[k,y] <= Recruit[k] /\
  Red[k,y] <= Work[k,y]
);

constraint forall(k in 1..K, y in 1..I)(
  Short[k,y] <= NumShortwork /\
  Short[k,y] <= Work[k,y] - Red[k,y]
);

constraint forall(k in 1..K, y in 1..I)(
  2 * (Work[k,y] - Red[k,y]) - Short[k,y] >= 2 * Requirement[k,y]
);

constraint forall(k in 1..K, y in 1..I)(
  Over[k,y] >= (Work[k,y] - Red[k,y]) - Requirement[k,y] /\
  Over[k,y] >= 0
);

constraint forall(y in 1..I)(
  sum(k in 1..K)(Over[k,y]) <= NumOverman
);

constraint forall(k in 1..K, y in 1..I-1)(
  Work[k,y+1] =
    round(
      (1.0 - MoreOneWaste[k]) * int2float(Work[k,y] - Red[k,y]) +
      (1.0 - LessOneWaste[k]) * int2float(Hire[k,y])
    )
);

solve minimize sum(k in 1..K, y in 1..I)(Red[k,y]);