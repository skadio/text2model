int: K;
int: I;

array[1..K, 1..I] of int: Requirement;

array[1..K] of int: Strength;
array[1..K] of float: LessOneWaste;
array[1..K] of float: MoreOneWaste;

array[1..K] of int: Recruit;                 % max recruits per year and category
array[1..K] of int: CostRedundancy;

int: NumOverman;                             % max total overmanning (heads)
array[1..K] of int: CostOverman;

int: NumShortwork;                           % max total short-time workers (heads)
array[1..K] of int: CostShort;

set of int: C = 1..K;
set of int: Y = 1..I;

% Decision variables
array[C, Y] of var 0..int_max: hire;         % recruits hired in year y, category c
array[C, Y] of var 0..int_max: redundant;    % redundancies in year y, category c
array[C, Y] of var 0..int_max: short;        % put on short-time working in year y, category c

array[C, Y] of var 0..int_max: staff;        % end-of-year staff after decisions/wastage

% Wastage modelling:
% - New hires in their first year: fraction LessOneWaste[c] leave by year end.
% - Existing (>=1 year service): fraction MoreOneWaste[c] leave by year end.
% Use conservative integer linearization via floor/ceil bounds.
array[C, Y] of var 0..int_max: waste_new;
array[C, Y] of var 0..int_max: waste_old;

% Initial staff (all are "old" at start)
constraint
  forall(c in C) (
    staff[c,1] <= Strength[c] + hire[c,1] - redundant[c,1] - waste_old[c,1] - waste_new[c,1]
  );

constraint
  forall(c in C) (
    staff[c,1] >= Strength[c] + hire[c,1] - redundant[c,1] - waste_old[c,1] - waste_new[c,1]
  );

% Dynamics for subsequent years
constraint
  forall(c in C, y in 2..I) (
    staff[c,y] = staff[c,y-1] + hire[c,y] - redundant[c,y] - waste_old[c,y] - waste_new[c,y]
  );

% Recruitment limits (per category per year)
constraint forall(c in C, y in Y) ( hire[c,y] <= Recruit[c] );

% Cannot short-work more than available staff in that year
constraint forall(c in C, y in Y) ( short[c,y] <= staff[c,y] );

% Total short-time limit across company
constraint forall(y in Y) ( sum(c in C)(short[c,y]) <= NumShortwork );

% Overmanning allowance: allow up to NumOverman extra heads over requirement
% Effective FTE delivered counts short-time workers as 0.5 FTE.
% So delivered FTE = staff - 0.5*short.
% Ensure delivered >= requirement (meet demand).
constraint
  forall(c in C, y in Y) (
    2*staff[c,y] - short[c,y] >= 2*Requirement[c,y]
  );

% Define overmanning heads as staff - requirement (can be negative => 0 by max)
array[C, Y] of var 0..int_max: over;
constraint forall(c in C, y in Y) (
  over[c,y] >= staff[c,y] - Requirement[c,y]
);
constraint forall(c in C, y in Y) (
  over[c,y] <= staff[c,y]
);

constraint forall(y in Y) ( sum(c in C)(over[c,y]) <= NumOverman );

% Wastage bounds (linearization)
% waste_new approx = LessOneWaste[c] * hire[c,y]
% waste_old approx = MoreOneWaste[c] * base_old where base_old is previous staff (or Strength for y=1)
constraint
  forall(c in C, y in Y) (
    waste_new[c,y] <= ceil(LessOneWaste[c] * int2float(Recruit[c])) * (hire[c,y] div max(1,Recruit[c])) + int2float(0)
  );

% Tighter and correct bounds using floor/ceil on variable directly:
constraint
  forall(c in C, y in Y) (
    waste_new[c,y] >= floor(LessOneWaste[c] * int2float(hire[c,y]))
  /\
    waste_new[c,y] <= ceil(LessOneWaste[c] * int2float(hire[c,y]))
  );

constraint
  forall(c in C) (
    waste_old[c,1] >= floor(MoreOneWaste[c] * int2float(Strength[c]))
  /\
    waste_old[c,1] <= ceil(MoreOneWaste[c] * int2float(Strength[c]))
  );

constraint
  forall(c in C, y in 2..I) (
    waste_old[c,y] >= floor(MoreOneWaste[c] * int2float(staff[c,y-1]))
  /\
    waste_old[c,y] <= ceil(MoreOneWaste[c] * int2float(staff[c,y-1]))
  );

% Objective: minimize redundancy + overmanning + short-time costs
var int: total_cost =
  sum(c in C, y in Y)(CostRedundancy[c] * redundant[c,y]) +
  sum(c in C, y in Y)(CostOverman[c] * over[c,y]) +
  sum(c in C, y in Y)(CostShort[c] * short[c,y]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "hire=\n", show(hire), "\n",
  "redundant=\n", show(redundant), "\n",
  "short=\n", show(short), "\n",
  "staff=\n", show(staff), "\n",
  "over=\n", show(over), "\n",
  "waste_new=\n", show(waste_new), "\n",
  "waste_old=\n", show(waste_old), "\n"
];