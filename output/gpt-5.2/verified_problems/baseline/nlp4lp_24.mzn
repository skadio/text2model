int: K;
int: I;

array[1..K, 1..I] of int: Requirement;
array[1..K] of int: Strength;

array[1..K] of float: LessOneWaste;   % wastage rate for <1 year service
array[1..K] of float: MoreOneWaste;   % wastage rate for >=1 year service

array[1..K] of int: Recruit;          % max recruits per year in each category
array[1..K] of int: CostRedundancy;   % redundancy cost per worker in each category

int: NumOverman;                      % max total overmanning across company
array[1..K] of int: CostOverman;      % cost per extra worker per year in each category

int: NumShortwork;                   % max short-time workers per category per year
array[1..K] of int: CostShort;        % cost per short-time worker per year in each category

set of int: C = 1..K;
set of int: Y = 1..I;

% Decision variables (per category, per year)
array[C, Y] of var 0..max(0, max(Recruit)): recruit;
array[C, Y] of var 0..max(Strength): redundancy;
array[C, Y] of var 0..max(Strength): shortwork;
array[C, Y] of var 0..NumOverman: overman;

% Workforce levels at start of each year, split by tenure:
% old = >=1 year service; new = <1 year service (only from last year's recruits)
array[C, 1..I+1] of var 0..sum(Strength) + I*max(Recruit): old;
array[C, 1..I+1] of var 0..sum(Strength) + I*max(Recruit): new;

% Initial condition: no recent recruitment, all current workers are old
constraint forall(c in C) (
  old[c,1] = Strength[c] /\
  new[c,1] = 0
);

% Yearly dynamics and feasibility
constraint forall(c in C, y in Y) (
  % limits
  recruit[c,y] <= Recruit[c] /\
  shortwork[c,y] <= NumShortwork /\
  
  % cannot lay off more than available at start of year
  redundancy[c,y] <= old[c,y] + new[c,y] /\
  
  % overmanning definition against effective supply meeting requirement
  ( (old[c,y] + new[c,y] - redundancy[c,y])
    - (Requirement[c,y] - shortwork[c,y] div 2) ) = overman[c,y] /\
  
  % meet requirement with effective FTE:
  % shortwork provides 0.5 FTE; the other half is a shortfall in FTE but still employed.
  (old[c,y] + new[c,y] - redundancy[c,y]) - shortwork[c,y] + (shortwork[c,y] div 2) >= Requirement[c,y] /\
  
  % Next year's tenure update with wastage:
  % Survivors among old after wastage rate MoreOneWaste
  old[c,y+1] = (old[c,y] - (redundancy[c,y] * old[c,y]) div max(1, old[c,y] + new[c,y]))
              - round(MoreOneWaste[c] * int2float(old[c,y])) 
              + new[c,y] - round(LessOneWaste[c] * int2float(new[c,y])) /\
  % New next year are this year's recruits
  new[c,y+1] = recruit[c,y]
);

% Total overmanning limit across company in each year
constraint forall(y in Y) (
  sum(c in C)(overman[c,y]) <= NumOverman
);

% Costs
var float: total_cost =
  sum(c in C, y in Y)(
      int2float(CostRedundancy[c] * redundancy[c,y])
    + int2float(CostOverman[c] * overman[c,y])
    + int2float(CostShort[c] * shortwork[c,y])
  );

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "recruit=\n", show(recruit), "\n",
  "redundancy=\n", show(redundancy), "\n",
  "shortwork=\n", show(shortwork), "\n",
  "overman=\n", show(overman), "\n",
  "old=\n", show(old), "\n",
  "new=\n", show(new), "\n"
];