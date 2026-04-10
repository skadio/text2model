% Manpower planning with recruitment, redundancy, overmanning and short-time working
% Objective: minimize total cost

% --------------------
% Parameters
% --------------------
int: K; % worker categories
int: I; % years / planning periods

array[1..K, 1..I] of int: Requirement;
array[1..K] of int: Strength;

array[1..K] of float: LessOneWaste;  % wastage rate for recruits (<1 year)
array[1..K] of float: MoreOneWaste;  % wastage rate for experienced (>=1 year)

array[1..K] of int: Recruit;         % max recruits per year per category
array[1..K] of int: CostRedundancy;  % redundancy cost per worker per category

int: NumOverman;                     % max overmanning allowed (whole company, per year)
array[1..K] of int: CostOverman;     % overmanning cost per worker-year per category

int: NumShortwork;                   % max short-time working allowed (whole company, per year)
array[1..K] of int: CostShort;       % short-time cost per worker-year per category

% --------------------
% Decision variables
% --------------------
array[1..K, 1..I] of var 0..max(Recruit): R;     % recruits in year t
array[1..K, 1..I] of var 0..sum(Strength): Red;  % redundancies in year t (from experienced pool)

array[1..K, 1..I] of var 0..NumOverman: Over;    % allowed overmanning (slack) per category/year
array[1..K, 1..I] of var 0..NumShortwork: Short; % number of people on short-time per category/year

array[1..K, 1..I] of var 0..(sum(Strength) + I*max(Recruit)): Exp; % experienced at start of year t
array[1..K, 1..I] of var 0..max(Recruit): New;   % new (<1y) at start of year t (previous year recruits)

var float: TotalCost;

% --------------------
% Constraints
% --------------------

% Recruitment limits (redundant due to variable bounds, but explicit is fine)
constraint forall(k in 1..K, t in 1..I) (R[k,t] <= Recruit[k]);

% Initial workforce: all current staff are experienced; no new staff at start
constraint forall(k in 1..K) (
  Exp[k,1] = Strength[k] /\
  New[k,1] = 0
);

% Redundancy cannot exceed experienced workforce available at start of year
constraint forall(k in 1..K, t in 1..I) (
  Red[k,t] <= Exp[k,t]
);

% Workforce evolution:
% End of year t (after redundancy and wastage) becomes start of year t+1.
% We avoid round() on decision expressions; instead, keep float via int2float and
% use a consistent integer approximation with floor().
constraint forall(k in 1..K, t in 1..I-1) (
  Exp[k,t+1] =
    floor(
      (1.0 - MoreOneWaste[k]) * int2float(Exp[k,t] - Red[k,t]) +
      (1.0 - LessOneWaste[k]) * int2float(R[k,t])
    ) /\
  New[k,t+1] = R[k,t]
);

% Short-time working cannot exceed available workers in that category/year
constraint forall(k in 1..K, t in 1..I) (
  Short[k,t] <= Exp[k,t] + New[k,t]
);

% Company-wide limits per year
constraint forall(t in 1..I) (
  sum(k in 1..K)(Over[k,t]) <= NumOverman /\
  sum(k in 1..K)(Short[k,t]) <= NumShortwork
);

% Requirement satisfaction using effective supply:
% Effective supply = (experienced after redundancy) + (effective recruits during year) - half-time loss
% Over provides allowed excess above requirement.
constraint forall(k in 1..K, t in 1..I) (
  let {
    var float: effSupply =
      int2float(Exp[k,t] - Red[k,t]) +
      (1.0 - LessOneWaste[k]) * int2float(R[k,t]) -
      0.5 * int2float(Short[k,t])
  } in
    effSupply >= int2float(Requirement[k,t]) /\
    effSupply <= int2float(Requirement[k,t]) + int2float(Over[k,t])
);

% Total cost: redundancy + overmanning + short-time
constraint
  TotalCost =
    sum(k in 1..K, t in 1..I)(
      int2float(CostRedundancy[k]) * int2float(Red[k,t]) +
      int2float(CostOverman[k]) * int2float(Over[k,t]) +
      int2float(CostShort[k]) * int2float(Short[k,t])
    );

% --------------------
% Objective
% --------------------
solve minimize TotalCost;