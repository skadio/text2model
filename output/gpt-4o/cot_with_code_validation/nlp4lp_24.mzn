int: K;                               % Number of worker categories
int: I;                               % Planning horizon (years)

array[1..K, 1..I] of float: Requirement;     % Man-power requirement per category & year
array[1..K]       of float: Strength;        % Current (experienced) work-force (> 1 year)

array[1..K] of float: LessOneWaste;          % Leaving rate (< 1 year)
array[1..K] of float: MoreOneWaste;          % Leaving rate (≥ 1 year)

array[1..K] of float: Recruit;              % Maximum external recruits per year & category
array[1..K] of float: CostRedundancy;       % Redundancy cost per worker

int:    NumOverman;                         % Company-wide limit on over-staffing
array[1..K] of float: CostOverman;          % Cost per over-manned worker

int:    NumShortwork;                       % Company-wide limit on short-time workers
array[1..K] of float: CostShort;            % Cost per short-time worker


% Decision variables
array[1..K, 1..I]   of var float: xRecruit;     % Recruits in year t
array[1..K, 1..I]   of var float: xRedund;      % Redundancies in year t
array[1..K, 1..I]   of var float: xShort;       % Short-time workers in year t
array[1..K, 1..I]   of var float: xOver;        % Over-manned workers in year t
array[1..K, 1..I+1] of var float: Exp;          % Experienced workers at start of each year


% Initial experienced work-force
constraint
  forall(k in 1..K) (
    Exp[k,1] = Strength[k]
  );

% Work-force evolution
constraint
  forall(k in 1..K, t in 1..I) (
     Exp[k,t+1] =
        (1.0 - MoreOneWaste[k]) * (Exp[k,t] - xRedund[k,t]) +
        (1.0 - LessOneWaste[k]) *  xRecruit[k,t]
  );

% Recruitment upper bounds
constraint
  forall(k in 1..K, t in 1..I) (
    xRecruit[k,t] <= Recruit[k]
  );

% Redundancies only from experienced workers
constraint
  forall(k in 1..K, t in 1..I) (
    xRedund[k,t] <= Exp[k,t]
  );

% Short-time workers limit
constraint
  forall(k in 1..K, t in 1..I) (
    xShort[k,t] <= Exp[k,t] + xRecruit[k,t] - xRedund[k,t]
  );

% Meet production requirement (allowing over-staff and short-time working)
constraint
  forall(k in 1..K, t in 1..I) (
    (Exp[k,t] + xRecruit[k,t] - xRedund[k,t])      % Workers on books
    - 0.5 * xShort[k,t]                            % Short-time counts as 0.5
    = Requirement[k,t] + xOver[k,t]                % Demand + possible over-staff
  );

% Company-wide yearly limits
constraint
  forall(t in 1..I) (
       sum(k in 1..K)(xShort[k,t]) <= NumShortwork /\
       sum(k in 1..K)(xOver[k,t])  <= NumOverman
  );

% Non-negativity
constraint
  forall(k in 1..K, t in 1..I) (
        xRecruit[k,t] >= 0 /\ xRedund[k,t] >= 0 /\
        xShort[k,t]  >= 0 /\ xOver[k,t]   >= 0
  ) /\
  forall(k in 1..K, t in 1..I+1) (
        Exp[k,t] >= 0
  );

% Cost minimisation
var float: TotalCost =
      sum(k in 1..K, t in 1..I)(
            CostRedundancy[k] * xRedund[k,t]  +
            CostOverman[k]    * xOver[k,t]    +
            CostShort[k]      * xShort[k,t]
      );

solve minimize TotalCost;