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

int: MAXSTAFF =
  max(k in 1..K)(
    Strength[k] + sum(i in 1..I)(Recruit[k])
  );

array[1..K, 1..I] of var 0..MAXSTAFF: staff;
array[1..K, 1..I] of var 0..max(k in 1..K)(Recruit[k]): recruited;
array[1..K, 1..I] of var 0..max(k in 1..K)(Strength[k]): redundant;
array[1..K, 1..I] of var 0..NumOverman: overman;
array[1..K, 1..I] of var 0..NumShortwork: shortwork;

var float: total_cost;

constraint forall(k in 1..K, i in 1..I) (
  recruited[k,i] <= Recruit[k]
);

constraint forall(k in 1..K, i in 1..I) (
  shortwork[k,i] <= NumShortwork
);

constraint forall(i in 1..I) (
  sum(k in 1..K)(overman[k,i]) <= NumOverman
);

constraint forall(k in 1..K) (
  staff[k,1] = Strength[k] - redundant[k,1] + recruited[k,1]
);

constraint forall(k in 1..K, i in 2..I) (
  staff[k,i] =
    staff[k,i-1]
    - redundant[k,i]
    + recruited[k,i]
    - round(MoreOneWaste[k] * int2float(staff[k,i-1]))
    - round(LessOneWaste[k] * int2float(recruited[k,i]))
);

constraint forall(k in 1..K, i in 1..I) (
  2 * staff[k,i] + shortwork[k,i] >= 2 * Requirement[k,i]
);

constraint forall(k in 1..K, i in 1..I) (
  staff[k,i] <= Requirement[k,i] + overman[k,i]
);

constraint total_cost =
  sum(k in 1..K, i in 1..I)(
      int2float(CostRedundancy[k] * redundant[k,i])
    + int2float(CostOverman[k] * overman[k,i])
    + int2float(CostShort[k] * shortwork[k,i])
  );

solve minimize total_cost;