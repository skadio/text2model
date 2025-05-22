% Parameters
int: K;                               % Number of worker categories
int: I;                               % Number of planning years

set of int: Categories = 1..K;
set of int: Years      = 1..I;

array[Categories, Years] of int: Requirement;      % Man-power requirement
array[Categories]          of int: Strength;       % Present strength ( > 1-year service )

array[Categories] of float: LessOneWaste;          % Given – not explicitly used
array[Categories] of float: MoreOneWaste;          % Given – not explicitly used

array[Categories]          of int: Recruit;        % Maximum external recruits / year
array[Categories]          of int: CostRedundancy; % Redundancy cost / worker

int: NumOverman;                                   % Company-wide over-manning limit / year
array[Categories] of int: CostOverman;             % Cost / over-manned worker

int: NumShortwork;                                 % Company-wide short-time limit / year
array[Categories] of int: CostShort;               % Cost / short-time worker


% Pre-calculated upper bounds
int: MaxRecruit  = max(c in Categories)(Recruit[c]);
int: MaxStrength = max(c in Categories)(Strength[c]);
int: MaxStaff    = MaxStrength + I * MaxRecruit;   % Crude global upper bound on staff


% Decision variables
array[Categories, Years] of var 0..MaxRecruit: Recruited;    % External recruits
array[Categories, Years] of var 0..MaxStaff:  Redundant;     % Redundancies
array[Categories, Years] of var 0..MaxStaff:  Shortwork;     % Workers on short-time
array[Categories, Years] of var 0..MaxStaff:  Overman;       % Extra staff above need
array[Categories, Years] of var 0..MaxStaff:  Staff;         % Staff employed at year end

var int: TotalCost;                                          % Objective value


% Constraints

% 1. Respect recruitment limits
constraint
  forall(c in Categories, y in Years)(
    Recruited[c,y] <= Recruit[c]
  );

% 2. Workforce balance (year 1)
constraint
  forall(c in Categories)(
    Staff[c,1] = Strength[c] + Recruited[c,1] - Redundant[c,1]
  );

% 3. Workforce balance (subsequent years)
constraint
  forall(c in Categories, y in 2..I)(
    Staff[c,y] = Staff[c,y-1] + Recruited[c,y] - Redundant[c,y]
  );

% 4. Production capacity:
%    Every short-time worker counts as 0.5 FTE
constraint
  forall(c in Categories, y in Years)(
    2 * Staff[c,y] - Shortwork[c,y]
      = 2 * Requirement[c,y] + 2 * Overman[c,y]
  );

% 5. Company-wide limits on over-manning and short-time working
constraint forall(y in Years)(
  sum(c in Categories)(Overman[c,y]) <= NumOverman
);

constraint forall(y in Years)(
  sum(c in Categories)(Shortwork[c,y]) <= NumShortwork
);

% 6. Logical bounds
constraint
  forall(c in Categories, y in Years)(
       Shortwork[c,y] <= Staff[c,y] /\
       Overman[c,y]   <= Staff[c,y]
  );

% 7. Redundancies cannot exceed available personnel
constraint
  forall(c in Categories)(
    Redundant[c,1] <= Strength[c] + Recruited[c,1]
  );

constraint
  forall(c in Categories, y in 2..I)(
    Redundant[c,y] <= Staff[c,y-1] + Recruited[c,y]
  );

% 8. Cost computation
constraint
  TotalCost =
    sum(c in Categories, y in Years)(
          CostRedundancy[c] * Redundant[c,y]
        + CostOverman[c]    * Overman[c,y]
        + CostShort[c]      * Shortwork[c,y]
    );


% Objective
solve minimize TotalCost;