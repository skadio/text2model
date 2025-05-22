int: K = 3;
int: I = 3;

set of int: CATS  = 1..K;
set of int: YEARS = 1..I;

array[CATS, YEARS] of int: Requirement =
  [| 1000, 1400, 1000
   |  500, 2000, 1500
   |    0, 2500, 2000 |];

array[CATS] of int: Strength        = [2000, 1500, 1000];
array[CATS] of float: LessOneWaste  = [0.25, 0.2, 0.1];
array[CATS] of float: MoreOneWaste  = [0.1, 0.05, 0.05];

array[CATS] of int: Recruit         = [500, 800, 500];
array[CATS] of int: CostRedundancy  = [200, 500, 500];

int: NumOverman                     = 150;
array[CATS] of int: CostOverman     = [1500, 2000, 3000];

int: NumShortwork                   = 50;
array[CATS] of int: CostShort       = [500, 400, 400];

int: MaxRecruit      = max(Recruit);
int: UB_workforce    = max([Strength[c] + I * Recruit[c] | c in CATS]);
int: UB_overman      = 2 * UB_workforce;
int: OverUnitsLimit  = 2 * NumOverman;

array[CATS, YEARS] of var 0..UB_workforce : Work;
array[CATS, YEARS] of var 0..MaxRecruit   : Recruits;
array[CATS, YEARS] of var 0..UB_workforce : Redundancy;
array[CATS, YEARS] of var 0..UB_workforce : ShortWork;
array[CATS, YEARS] of var 0..UB_overman   : Overman;

constraint
  forall(c in CATS)(Work[c,1] == Strength[c]);

constraint
  forall(c in CATS, y in YEARS)(Recruits[c,y] <= Recruit[c]);

constraint
  forall(c in CATS, y in YEARS)(
       Redundancy[c,y] <= Work[c,y] /\
       ShortWork[c,y]  <= Work[c,y]
  );

constraint
  forall(c in CATS, y in 1..I-1)(
    Work[c,y+1] == Work[c,y] + Recruits[c,y] - Redundancy[c,y]
  );

constraint
  forall(c in CATS, y in YEARS)(
    2 * Work[c,y] - ShortWork[c,y] - 2 * Requirement[c,y] == Overman[c,y]
  );

constraint
  forall(y in YEARS)(
       sum(c in CATS)(Overman[c,y])   <= OverUnitsLimit /\
       sum(c in CATS)(ShortWork[c,y]) <= NumShortwork
  );

var float: TotalCost =
  sum(c in CATS, y in YEARS)(
        1.0 * CostRedundancy[c] * Redundancy[c,y]
      + 0.5 * CostOverman[c]    * Overman[c,y]
      + 1.0 * CostShort[c]      * ShortWork[c,y]
  );

solve minimize TotalCost;