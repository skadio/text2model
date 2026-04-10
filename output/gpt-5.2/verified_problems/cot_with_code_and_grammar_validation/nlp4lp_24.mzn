%-----------------------------
% Manpower planning model
%-----------------------------

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

int: MAXSTAFF = sum(k in 1..K)(Strength[k] + I * Recruit[k]);
int: MAXRECRUIT = max(k in 1..K)(Recruit[k]);

array[1..K, 1..I] of var 0..MAXRECRUIT: xRecruit;
array[1..K, 1..I] of var 0..MAXSTAFF: xRedundant;

array[1..K, 1..I] of var 0..NumOverman: xOver;
array[1..K, 1..I] of var 0..NumShortwork: xShort;

array[1..K, 1..I] of var 0..MAXSTAFF: StaffStart;
array[1..K, 1..I] of var 0..MAXSTAFF: StaffEnd;

var float: TotalCost;

constraint forall(k in 1..K, t in 1..I) (
  xRecruit[k,t] <= Recruit[k]
);

constraint forall(k in 1..K) (
  StaffStart[k,1] = Strength[k]
);

constraint forall(k in 1..K, t in 2..I) (
  StaffStart[k,t] = StaffEnd[k,t-1]
);

constraint forall(k in 1..K, t in 1..I) (
  StaffEnd[k,t] =
    round(
      (1.0 - MoreOneWaste[k]) * int2float(StaffStart[k,t]) +
      (1.0 - LessOneWaste[k]) * int2float(xRecruit[k,t])
    ) - xRedundant[k,t]
);

constraint forall(k in 1..K, t in 1..I) (
  StaffEnd[k,t] >= 0
);

constraint forall(k in 1..K, t in 1..I) (
  2 * (StaffEnd[k,t] + xOver[k,t]) + xShort[k,t] >= 2 * Requirement[k,t]
);

constraint forall(t in 1..I) (
  sum(k in 1..K)(xOver[k,t]) <= NumOverman /\
  sum(k in 1..K)(xShort[k,t]) <= NumShortwork
);

constraint
  TotalCost =
    sum(k in 1..K, t in 1..I)(
        int2float(CostRedundancy[k]) * int2float(xRedundant[k,t]) +
        int2float(CostOverman[k])    * int2float(xOver[k,t]) +
        int2float(CostShort[k])      * int2float(xShort[k,t])
    );

solve minimize TotalCost;