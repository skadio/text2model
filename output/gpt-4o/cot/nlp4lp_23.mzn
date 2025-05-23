int: K;
int: I;

set of int: Categories = 1..K;
set of int: Years      = 1..I;

array[Categories, Years] of int: Requirement;
array[Categories]        of int: Strength;
array[Categories]        of float: LessOneWaste;
array[Categories]        of float: MoreOneWaste;
array[Categories]        of int: Recruit;
array[Categories]        of int: CostRedundancy;
int: NumOverman;
array[Categories]        of int: CostOverman;
int: NumShortwork;
array[Categories]        of int: CostShort;

% Derived constants
int: MaxRecruit  = max([Recruit[k]  | k in Categories]);
int: MaxStrength = max([Strength[k] | k in Categories]);
int: BigM        = MaxStrength + I * MaxRecruit;

% Decision variables
array[Categories, Years] of var 0..BigM         : S;        % staff with >1 year service at start of year
array[Categories, Years] of var 0..MaxRecruit   : R;        % recruits in year
array[Categories, Years] of var 0..BigM         : Redund;   % redundancies in year
array[Categories, Years] of var 0..NumShortwork : ShortW;   % short-time workers in year

% Initial labour force
constraint
  forall(k in Categories)(
    S[k,1] = Strength[k]
  );

% Workforce evolution (natural wastage)
constraint
  forall(k in Categories, i in 1..I-1)(
    S[k,i+1] =
      round(
        int2float(S[k,i] - Redund[k,i]) * (1.0 - MoreOneWaste[k]) +
        int2float(R[k,i])               * (1.0 - LessOneWaste[k])
      )
  );

% Recruitment limits
constraint
  forall(k in Categories, i in Years)(
    R[k,i] <= Recruit[k]
  );

% Redundancies cannot exceed available long-service staff
constraint
  forall(k in Categories, i in Years)(
    Redund[k,i] <= S[k,i]
  );

% Short-time working cannot exceed available workers
constraint
  forall(k in Categories, i in Years)(
    ShortW[k,i] <= S[k,i] + R[k,i] - Redund[k,i]
  );

% Company-wide short-time working limit per year
constraint
  forall(i in Years)(
    sum(k in Categories)(ShortW[k,i]) <= NumShortwork
  );

% Production requirements (short-time counts as 0.5 worker)
constraint
  forall(k in Categories, i in Years)(
    int2float(S[k,i] + R[k,i] - Redund[k,i]) -
    0.5 * int2float(ShortW[k,i]) >= int2float(Requirement[k,i])
  );

% Overmanning limit
constraint
  forall(i in Years)(
    sum(k in Categories)(S[k,i] + R[k,i] - Redund[k,i]) -
    sum(k in Categories)(Requirement[k,i]) <= NumOverman
  );

% Objective: minimise total redundancies
solve minimize
  sum(k in Categories, i in Years)(Redund[k,i]);