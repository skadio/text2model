% -------------------- Parameters --------------------
array[int,int] of int: Requirement;

set of int: Cat  = index_set_1of2(Requirement);   % worker categories
set of int: Year = index_set_2of2(Requirement);   % planning years
set of int: Year0 = 0..max(Year);                 % add year 0 for initial workforce

int: K = card(Cat);
int: I = card(Year);

array[Cat] of int:   Strength;          % present workforce (all > 1 year service)
array[Cat] of float: LessOneWaste;      % wastage for new recruits (<1 year)
array[Cat] of float: MoreOneWaste;      % wastage for existing staff (≥1 year)

array[Cat] of int:   Recruit;           % maximum recruits per year/category
array[Cat] of float: CostRedundancy;    % redundancy cost per employee

int: NumOverman;                        % company-wide over-manning limit
array[Cat] of float: CostOverman;       % (not used in objective, kept for completeness)

int: NumShortwork;                      % company-wide short-work limit
array[Cat] of float: CostShort;         % (not used in objective, kept for completeness)

% ----------------- Derived constants ----------------
int: MaxRecruit   = max(Recruit);
int: MaxStrength  = max(Strength);
int: BigWork      = MaxStrength + I * MaxRecruit;

% -------------------- Variables ---------------------
array[Cat, Year]  of var 0..MaxRecruit  : Recruited;
array[Cat, Year]  of var 0..NumShortwork: ShortWork;
array[Cat, Year]  of var 0..NumOverman  : OverMan;
array[Cat, Year]  of var 0..BigWork     : Redundancy;

array[Cat, Year0] of var 0.0..int2float(BigWork): Workforce;

% --------------- Objective expression ---------------
var float: TotalRedundancyCost =
    sum(k in Cat, t in Year)(CostRedundancy[k] * int2float(Redundancy[k,t]));

% -------------------- Constraints -------------------

% Initial workforce (all employees have >1-year service)
constraint
  forall(k in Cat)(
    Workforce[k,0] = int2float(Strength[k])
  );

% Recruitment upper bounds
constraint
  forall(k in Cat, t in Year)(
    Recruited[k,t] <= Recruit[k]
  );

% Workforce evolution with wastage, recruitment and redundancy             
constraint
  forall(k in Cat, t in Year)(
    Workforce[k,t] =
        (1.0 - MoreOneWaste[k]) * (Workforce[k,t-1] - int2float(Redundancy[k,t])) +
        (1.0 - LessOneWaste[k]) * int2float(Recruited[k,t])
  );

% Production capacity balance (allowing over-manning & short-work)
constraint
  forall(k in Cat, t in Year)(
        (Workforce[k,t-1] - int2float(Redundancy[k,t]))
      - 0.5 * int2float(ShortWork[k,t])
    = int2float(Requirement[k,t]) + int2float(OverMan[k,t])
  );

% Company-wide limits on over-manning and short-work
constraint
  forall(t in Year)(
    sum(k in Cat)(OverMan[k,t])   <= NumOverman /\ 
    sum(k in Cat)(ShortWork[k,t]) <= NumShortwork
  );

% Cannot dispense with or short-work more people than available             
constraint
  forall(k in Cat, t in Year)(
    int2float(Redundancy[k,t] + ShortWork[k,t]) <= Workforce[k,t-1]
  );

% ---------------------- Solve -----------------------
solve minimize TotalRedundancyCost;