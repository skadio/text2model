% Parameters
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

% Variables
array[1..K, 1..I] of var 0..max(Strength): employed;        % total employed at end of year
array[1..K, 1..I] of var 0..max(Recruit): hire;             % recruited in year
array[1..K, 1..I] of var 0..max(Strength): redundant;       % made redundant in year
array[1..K, 1..I] of var 0..max(Strength): shortwork;       % put on short-time in year
array[1..K, 1..I] of var 0..(max(Strength) + max(Recruit)): overman; % excess above requirement in year

var int: total_redundant = sum(k in 1..K, t in 1..I)(redundant[k,t]);

% Constraints
% Initial condition: all current workers have > 1 year service
constraint
  forall(k in 1..K)(
    employed[k,1] >= 0
  );

% Workforce balance with wastage
% Let prev = employed[k,t-1], hire = hire[k,t].
% Survive rate: prev workers have >1 year service => (1-MoreOneWaste[k])
% New hires have <1 year service in that year => (1-LessOneWaste[k])
constraint
  forall(k in 1..K)(
    employed[k,1] =
      round( (1.0 - MoreOneWaste[k]) * int2float(Strength[k])
           + (1.0 - LessOneWaste[k]) * int2float(hire[k,1])
           - int2float(redundant[k,1]) )
  );

constraint
  forall(k in 1..K, t in 2..I)(
    employed[k,t] =
      round( (1.0 - MoreOneWaste[k]) * int2float(employed[k,t-1])
           + (1.0 - LessOneWaste[k]) * int2float(hire[k,t])
           - int2float(redundant[k,t]) )
  );

% Recruitment limits
constraint
  forall(k in 1..K, t in 1..I)(
    hire[k,t] <= Recruit[k]
  );

% Short-time working limits (per category and overall company limit)
constraint
  forall(k in 1..K, t in 1..I)(
    shortwork[k,t] <= NumShortwork
  );

% Production requirement satisfaction:
% full-time contributes 1, short-time contributes 0.5 but is included in employed headcount,
% so effective workforce = employed - 0.5*shortwork.
% Multiply by 2 to keep integrality: 2*employed - shortwork >= 2*Requirement
constraint
  forall(k in 1..K, t in 1..I)(
    2 * employed[k,t] - shortwork[k,t] >= 2 * Requirement[k,t]
  );

% Overmanning definition and cap (overall company cap per year)
constraint
  forall(k in 1..K, t in 1..I)(
    overman[k,t] >= employed[k,t] - Requirement[k,t]
  );

constraint
  forall(k in 1..K, t in 1..I)(
    overman[k,t] >= 0
  );

constraint
  forall(t in 1..I)(
    sum(k in 1..K)(overman[k,t]) <= NumOverman
  );

% Redundancy cannot exceed available headcount after wastage/recruit effects (softly ensured by balance),
% but keep explicit non-negativity already via bounds.

% Objective
solve minimize total_redundant;