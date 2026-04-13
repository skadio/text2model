% Manpower planning with recruitment, redundancy, short-time working, wastage, and overmanning
% Objective: minimize total redundancies

include "globals.mzn";

%----------------------------
% Parameters (from data)
%----------------------------
% Requirements is given as array2d(1..K, 1..I, ...)
array[int, int] of int: Requirement;

int: K = max(index_set_1of2(Requirement));
int: I = max(index_set_2of2(Requirement));

array[1..K] of int: Strength;
array[1..K] of float: LessOneWaste;
array[1..K] of float: MoreOneWaste;
array[1..K] of int: Recruit;

array[1..K] of int: CostRedundancy; % not used in objective (headcount objective)
int: NumOverman;
array[1..K] of int: CostOverman;    % not used
int: NumShortwork;
array[1..K] of int: CostShort;      % not used

%----------------------------
% Decision variables
%----------------------------
array[1..K, 1..I] of var 0..sum(Strength): workforce;          % start-of-year headcount
array[1..K, 1..I] of var 0..max(Recruit): recruited;           % recruited during year t
array[1..K, 1..I] of var 0..sum(Strength): redundant;          % redundancies during year t
array[1..K, 1..I] of var 0..NumShortwork: shortwork;           % on short-time during year t
array[1..K, 1..I] of var 0..NumOverman: overman;               % overmanning headcount slack

var 0..(I * sum(Strength) + I * K * max(Recruit)): total_redundancy;

%----------------------------
% Constraints
%----------------------------
% Initial workforce (all have >= 1 year service)
constraint forall(k in 1..K) (
  workforce[k, 1] = Strength[k]
);

% Recruitment limits per category-year
constraint forall(k in 1..K, t in 1..I) (
  recruited[k, t] <= Recruit[k]
);

% Redundancy cannot exceed available headcount
constraint forall(k in 1..K, t in 1..I) (
  redundant[k, t] <= workforce[k, t]
);

% Short-time working cannot exceed remaining workforce after redundancy
constraint forall(k in 1..K, t in 1..I) (
  shortwork[k, t] <= workforce[k, t] - redundant[k, t]
);

% Requirement satisfaction:
% Full-time effective = (workforce - redundant - shortwork) + 0.5*shortwork = workforce - redundant - 0.5*shortwork
% Add overman slack (headcount) and use integer arithmetic by doubling.
constraint forall(k in 1..K, t in 1..I) (
  2*(workforce[k, t] - redundant[k, t]) - shortwork[k, t] + 2*overman[k, t] >= 2*Requirement[k, t]
);

% Company-wide overmanning cap per year
constraint forall(t in 1..I) (
  sum(k in 1..K)(overman[k, t]) <= NumOverman
);

% Workforce evolution with wastage:
% Next year's workforce = survivors of (existing after redundancy) + survivors of recruits
% Use round() to keep integer headcounts.
constraint forall(k in 1..K, t in 1..I-1) (
  workforce[k, t+1] =
    round(
      (1.0 - MoreOneWaste[k]) * int2float(workforce[k, t] - redundant[k, t])
    + (1.0 - LessOneWaste[k]) * int2float(recruited[k, t])
    )
);

% Total redundancy
constraint total_redundancy = sum(k in 1..K, t in 1..I)(redundant[k, t]);

%----------------------------
% Objective
%----------------------------
solve minimize total_redundancy;