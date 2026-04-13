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

set of int: RES = 1..K;
set of int: YRS = 1..I;

% Decision variables (per year, per category)
array[RES, YRS] of var 0..Strength[max(RES)] + sum(Recruit): R;   % recruited in year y (new hires)
array[RES, YRS] of var 0..Strength[max(RES)] + sum(Recruit): D;   % redundancies in year y
array[RES, YRS] of var 0..Strength[max(RES)] + sum(Recruit): O;   % overmanning (extra full-time workers above requirement)
array[RES, YRS] of var 0..Strength[max(RES)] + sum(Recruit): S;   % short-time workers count

% Workforce tracking
array[RES, 0..I] of var 0..Strength[max(RES)] + sum(Recruit): Exp;  % >1 year service at start of year y (y=0 is current)
array[RES, 0..I] of var 0..Strength[max(RES)] + sum(Recruit): New;  % <1 year service at start of year y

constraint forall(k in RES) (
  Exp[k,0] = Strength[k] /\
  New[k,0] = 0
);

% Recruitment limits
constraint forall(k in RES, y in YRS) (
  R[k,y] <= Recruit[k]
);

% Short-time working limits
constraint forall(k in RES, y in YRS) (
  S[k,y] <= NumShortwork
);

% Overmanning limit (company-wide, per year)
constraint forall(y in YRS) (
  sum(k in RES)(O[k,y]) <= NumOverman
);

% Annual flow and feasibility constraints
constraint forall(k in RES, y in YRS) (
  % Cannot shortwork more than total workforce at start of year
  S[k,y] <= Exp[k,y-1] + New[k,y-1] /\
  % Redundancies cannot exceed available (start-of-year) workforce
  D[k,y] <= Exp[k,y-1] + New[k,y-1] /\
  % Demand satisfaction using effective workforce:
  % full-time workers count as 1; short-time workers count as 0.5 (i.e., 2*S counts as S full-time)
  % Effective workforce = (Exp+New - D - S) + 0.5*S = Exp+New - D - 0.5*S
  2 * (Exp[k,y-1] + New[k,y-1] - D[k,y]) - S[k,y] >= 2 * Requirement[k,y] /\
  % Overmanning defines how much effective workforce exceeds requirement (can be 0..)
  2 * O[k,y] = (2 * (Exp[k,y-1] + New[k,y-1] - D[k,y]) - S[k,y]) - 2 * Requirement[k,y]
);

% Wastage and ageing of workforce:
% - At end of year y, the "new" cohort (those recruited in year y) becomes the "new" at start of y+1,
%   but experiences <1yr wastage over that year.
% - The experienced cohort at start of year y survives with >1yr wastage over the year, then combines
%   with survivors from previous year's new cohort (who age into experienced).
constraint forall(k in RES, y in YRS) (
  let {
    var int: exp_start = Exp[k,y-1],
    var int: new_start = New[k,y-1],
    var int: total_start = exp_start + new_start,
    var int: exp_after_red = max(0, exp_start - D[k,y]),           % redundancies removed from experienced first (modeling choice)
    var int: red_left = max(0, D[k,y] - exp_start),
    var int: new_after_red = max(0, new_start - red_left)          % remaining redundancies, if any, remove new
  } in
  (
    % New at start of next year are this year's recruits after <1yr wastage
    New[k,y] = round( (1.0 - LessOneWaste[k]) * R[k,y] ) /\
    % Experienced at start of next year come from:
    % (a) experienced survivors after >1yr wastage
    % (b) new survivors (who age into experienced) after <1yr wastage
    Exp[k,y] = round( (1.0 - MoreOneWaste[k]) * exp_after_red + (1.0 - LessOneWaste[k]) * new_after_red )
  )
);

% Objective: minimize redundancies (primary), with secondary tie-break by total cost
var int: total_redundancy = sum(k in RES, y in YRS)(D[k,y]);

var int: total_cost =
    sum(k in RES, y in YRS)(CostRedundancy[k] * D[k,y])
  + sum(k in RES, y in YRS)(CostOverman[k] * O[k,y])
  + sum(k in RES, y in YRS)(CostShort[k] * S[k,y]);

solve minimize 1000000000 * total_redundancy + total_cost;

output [
  "TotalRedundancy=", show(total_redundancy), "\n",
  "TotalCost=", show(total_cost), "\n\n",
  "Yearly decisions (k=1..K, y=1..I)\n",
  "Recruit=\n", show(R), "\n",
  "Redundancy=\n", show(D), "\n",
  "Shortwork=\n", show(S), "\n",
  "Overman=\n", show(O), "\n\n",
  "Workforce at start of each year (y=0..I)\n",
  "Exp=\n", show(Exp), "\n",
  "New=\n", show(New), "\n"
];