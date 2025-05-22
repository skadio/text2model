% Workforce Planning Model

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input data (to be provided in a .dzn file)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

array[int,int] of int: Requirement;           % Requirement[type,year]

set of int: TYPES = index_set_1of2(Requirement);
set of int: YEARS = index_set_2of2(Requirement);

int: numTypes  = card(TYPES);
int: numYears  = card(YEARS);

/* Workforce information */
array[TYPES] of int:   Strength;              % current manpower (> 1-year service)
array[TYPES] of float: LessOneWaste;          % wastage rate (< 1-year service)
array[TYPES] of float: MoreOneWaste;          % wastage rate (> 1-year service)

/* Operational limits & costs (limits shown for completeness) */
array[TYPES] of int: Recruit;                 % maximum external recruits per year
array[TYPES] of int: CostRedundancy;          % redundancy cost
int:               NumOverman;                % company-wide overmanning limit
array[TYPES] of int: CostOverman;             % overmanning cost
int:               NumShortwork;              % limit on short-time workers per category/year
array[TYPES] of int: CostShort;               % short-time cost

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Derived constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

int: Big =
        sum(k in TYPES)(Strength[k])
      + numYears * sum(k in TYPES)(Recruit[k]);

float: BigFloat = int2float(Big);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decision variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

array[TYPES,YEARS] of var 0..Big:            X;     % recruits
array[TYPES,YEARS] of var 0..Big:            R;     % redundancies
array[TYPES,YEARS] of var 0..NumShortwork:   S;     % short-time workers

array[TYPES,0..numYears] of var 0.0..BigFloat: W;   % workforce at start of each year
array[TYPES,YEARS]        of var 0.0..BigFloat: Supply; % effective full-time supply
array[TYPES,YEARS]        of var 0.0..BigFloat: Over;   % overmanning (≥0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Initial workforce (all with >1-year service) */
constraint
  forall(k in TYPES)(
    W[k,0] = int2float(Strength[k])
  );

/* Workforce evolution with wastage */
constraint
  forall(k in TYPES, t in YEARS)(
    W[k,t] =
        ( W[k,t-1] - int2float(R[k,t]) ) * (1.0 - MoreOneWaste[k])
      + int2float(X[k,t])                * (1.0 - LessOneWaste[k])
  );

/* Recruitment and redundancy feasibility */
constraint
  forall(k in TYPES, t in YEARS)(
        X[k,t]                 <= Recruit[k] /\
        int2float(R[k,t])      <= W[k,t-1]
  );

/* Short-time working bounds */
constraint
  forall(k in TYPES, t in YEARS)(
        int2float(S[k,t]) <= int2float(NumShortwork) /\
        int2float(S[k,t]) <= W[k,t-1] + int2float(X[k,t]) - int2float(R[k,t])
  );

/* Effective full-time equivalent supply */
constraint
  forall(k in TYPES, t in YEARS)(
    Supply[k,t] = W[k,t-1]
                + int2float(X[k,t])
                - int2float(R[k,t])
                - 0.5 * int2float(S[k,t])
  );

/* Meet or exceed demand */
constraint
  forall(k in TYPES, t in YEARS)(
    Supply[k,t] >= int2float(Requirement[k,t])
  );

/* Define overmanning */
constraint
  forall(k in TYPES, t in YEARS)(
    Over[k,t] = Supply[k,t] - int2float(Requirement[k,t])
  );

/* Company-wide overmanning limit */
constraint
  forall(t in YEARS)(
    sum(k in TYPES)(Over[k,t]) <= int2float(NumOverman)
  );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

solve minimize
     sum(k in TYPES, t in YEARS)(R[k,t]);