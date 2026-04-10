% Manpower planning with recruitment, redundancy, overmanning and short-time working
% Robust to missing K and I in the data file by deriving them from Requirement.

% -----------------------
% Parameters (data)
% -----------------------
array[1..3, 1..3] of int: Requirement; % required effective manpower per category and year

int: K = length(index_set_1of2(Requirement));
int: I = length(index_set_2of2(Requirement));

array[1..K] of int: Strength;              % initial workforce (>1 year service)
array[1..K] of float: LessOneWaste;        % wastage rate for <1 year service
array[1..K] of float: MoreOneWaste;        % wastage rate for >1 year service
array[1..K] of int: Recruit;               % max recruits per year by category
array[1..K] of int: CostRedundancy;        % redundancy cost per worker
int: NumOverman;                           % max total overmanning company-wide
array[1..K] of int: CostOverman;           % cost per overmanned worker per year
int: NumShortwork;                         % max short-time workers per category/year
array[1..K] of int: CostShort;             % cost per short-time worker per year

% Scaling factor for wastage rates (percent-based linearization)
int: S = 100;

% -----------------------
% Decision variables
% -----------------------
array[1..K, 1..I] of var 0..max(Recruit): recruit;
array[1..K, 1..I] of var 0..(max(Strength) + max(Recruit)): redundant;
array[1..K, 1..I] of var 0..(max(Strength) + max(Recruit)): workforce;
array[1..K, 1..I] of var 0..(max(Strength) + max(Recruit)): shortwork;
array[1..K, 1..I] of var 0..(max(Strength) + max(Recruit)): overman;

array[1..K, 1..I] of var float: effectiveStaff;
var float: totalCost;

% -----------------------
% Constraints
% -----------------------

% Recruitment limits per category/year
constraint forall(k in 1..K, t in 1..I) (
  recruit[k,t] <= Recruit[k]
);

% Workforce flow with wastage (all initial Strength are >1 year service)
constraint forall(k in 1..K) (
  workforce[k,1] =
    (((S - round(S * MoreOneWaste[k])) * Strength[k]) div S) +
    (((S - round(S * LessOneWaste[k])) * recruit[k,1]) div S) -
    redundant[k,1]
);

constraint forall(k in 1..K, t in 2..I) (
  workforce[k,t] =
    (((S - round(S * MoreOneWaste[k])) * workforce[k,t-1]) div S) +
    (((S - round(S * LessOneWaste[k])) * recruit[k,t]) div S) -
    redundant[k,t]
);

% Short-time working limits
constraint forall(k in 1..K, t in 1..I) (
  shortwork[k,t] <= workforce[k,t]
);
constraint forall(k in 1..K, t in 1..I) (
  shortwork[k,t] <= NumShortwork
);

% Effective staff: shortwork counts as 0.5 of a full-time worker
constraint forall(k in 1..K, t in 1..I) (
  effectiveStaff[k,t] = int2float(workforce[k,t]) - 0.5 * int2float(shortwork[k,t])
);

% Meet requirements in effective staff terms
constraint forall(k in 1..K, t in 1..I) (
  effectiveStaff[k,t] >= int2float(Requirement[k,t])
);

% Overmanning definition and nonnegativity
constraint forall(k in 1..K, t in 1..I) (
  overman[k,t] = workforce[k,t] - Requirement[k,t]
);
constraint forall(k in 1..K, t in 1..I) (
  overman[k,t] >= 0
);

% Total overmanning cap (company-wide)
constraint sum(k in 1..K, t in 1..I) (overman[k,t]) <= NumOverman;

% -----------------------
% Objective
% -----------------------
constraint totalCost =
  sum(k in 1..K, t in 1..I) (
      int2float(CostRedundancy[k] * redundant[k,t])
    + int2float(CostOverman[k]    * overman[k,t])
    + int2float(CostShort[k]      * shortwork[k,t])
  );

solve minimize totalCost;