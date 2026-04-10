% Parameters
int: K; % number of worker categories
int: I; % number of years (planning periods)

array[1..K, 1..I] of int: Requirement;   % required effective manpower
array[1..K] of int: Strength;            % initial workforce (>1 year service)

array[1..K] of float: LessOneWaste;      % wastage rate for <1 year service
array[1..K] of float: MoreOneWaste;      % wastage rate for >1 year service

array[1..K] of int: Recruit;             % max recruits per year per category
array[1..K] of int: CostRedundancy;      % redundancy cost per worker per category

int: NumOverman;                         % max total overmanning (all categories, per year)
array[1..K] of int: CostOverman;         % overmanning cost per worker per year

int: NumShortwork;                       % max total short-time workers (all categories, per year)
array[1..K] of int: CostShort;           % short-time cost per worker per year

% Variables
array[1..K, 1..I] of var 0..max(Strength): old;                 % >1 year service at start of year t
array[1..K, 1..I] of var 0..max(Recruit): new;                  % <1 year service at start of year t

array[1..K, 1..I] of var 0..max(Recruit): hire;                 % hired during year t (become new at t+1)
array[1..K, 1..I] of var 0..(max(Strength) + max(Recruit)): red; % redundancies during year t

array[1..K, 1..I] of var 0..(max(Strength) + max(Recruit)): over; % overmanning amount (slack) in year t
array[1..K, 1..I] of var 0..(max(Strength) + max(Recruit)): short; % on short-time in year t

% Constraints
% Initial condition: all initial workers are > 1 year service, and no "new" workers yet
constraint forall(k in 1..K) (
  old[k,1] = Strength[k] /\
  new[k,1] = 0
);

% Hiring bounds
constraint forall(k in 1..K, t in 1..I) (
  hire[k,t] <= Recruit[k]
);

% Flow balance with wastage and decisions
% For t < I, define next year's starting workforce composition
% - Those who are "new" become "old" next year after <1-year wastage
% - Those who are "old" remain "old" next year after >1-year wastage
% - Hiring in year t becomes "new" at start of year t+1
constraint forall(k in 1..K, t in 1..I-1) (
  old[k,t+1] + new[k,t+1] =
    (old[k,t] + new[k,t]) - red[k,t] - (over[k,t] - over[k,t]) % no-op to keep linear form stable
    + hire[k,t] % hires add to next year's headcount via new[k,t+1]
);

% Link new hires to next year's "new" pool
constraint forall(k in 1..K, t in 1..I-1) (
  new[k,t+1] = hire[k,t]
);

% Wastage reduces available effective workforce within the year.
% Effective workforce contributed by:
% - old workers: (1 - MoreOneWaste[k])
% - new workers: (1 - LessOneWaste[k])
% Short-time workers contribute half of an effective full-time worker.
% Overmanning is slack to allow up to NumOverman above requirement (penalized).
constraint forall(k in 1..K, t in 1..I) (
  (1.0 - MoreOneWaste[k]) * int2float(old[k,t])
+ (1.0 - LessOneWaste[k]) * int2float(new[k,t])
- 0.5 * int2float(short[k,t])
= int2float(Requirement[k,t] + over[k,t])
);

% Cannot put more workers on short-time than available headcount in that category/year
constraint forall(k in 1..K, t in 1..I) (
  short[k,t] <= old[k,t] + new[k,t]
);

% Total limits across company per year
constraint forall(t in 1..I) (
  sum(k in 1..K)(over[k,t]) <= NumOverman
);

constraint forall(t in 1..I) (
  sum(k in 1..K)(short[k,t]) <= NumShortwork
);

% Redundancy cannot exceed available workforce in that year
constraint forall(k in 1..K, t in 1..I) (
  red[k,t] <= old[k,t] + new[k,t]
);

% Objective
var float: TotalCost =
  sum(k in 1..K, t in 1..I)(
      int2float(CostRedundancy[k]) * int2float(red[k,t])
    + int2float(CostOverman[k])    * int2float(over[k,t])
    + int2float(CostShort[k])      * int2float(short[k,t])
  );

solve minimize TotalCost;