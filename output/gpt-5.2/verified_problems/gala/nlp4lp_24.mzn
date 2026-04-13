include "globals.mzn";

%========================
% Input data (.dzn)
%========================
int: K;                               % number of worker categories
int: I;                               % number of years (planning periods)

array[1..K, 1..I] of int: Requirement; % required effective manpower per category per year

array[1..K] of int: Strength;          % initial workforce (>1 year service)

array[1..K] of float: LessOneWaste;    % wastage rate for <1 year service (fraction leaving)
array[1..K] of float: MoreOneWaste;    % wastage rate for >1 year service (fraction leaving)

array[1..K] of int: Recruit;           % max recruits per category per year

array[1..K] of int: CostRedundancy;    % redundancy cost per worker in category

int: NumOverman;                      % max total overmanning allowed (heads) per year across all categories
array[1..K] of int: CostOverman;       % cost per overmanned head per year

int: NumShortwork;                    % max total short-time workers allowed (heads) per year across all categories
array[1..K] of int: CostShort;         % cost per short-time head per year

%========================
% Helper constants / scaling
% (We scale rates by 1000 to keep integrality.)
%========================
int: SCALE = 1000;
array[1..K] of int: wLess = [ round(LessOneWaste[k] * SCALE) | k in 1..K ];
array[1..K] of int: wMore = [ round(MoreOneWaste[k] * SCALE) | k in 1..K ];

% Big-M upper bound for workforce counts
int: MAXW = max([Strength[k] + I * Recruit[k] + NumOverman | k in 1..K]);

%========================
% Decision variables
%========================
% Workforce by category/year split into:
%   Old = employed > 1 year at start of year t
%   New = recruited during year t (have < 1 year service during that year)
array[1..K, 1..I] of var 0..MAXW: Old;
array[1..K, 1..I] of var 0..MAXW: New;

% Redundancies applied to Old workforce at start of each year
array[1..K, 1..I] of var 0..MAXW: Redundant;

% Short-time working (heads) during year t
array[1..K, 1..I] of var 0..MAXW: Short;

% Overmanning slack (heads) during year t (extra full-time equivalents above requirement)
array[1..K, 1..I] of var 0..MAXW: Over;

% Survivors after wastage, forming next year's Old
array[1..K, 1..I] of var 0..MAXW: SurviveOld;
array[1..K, 1..I] of var 0..MAXW: SurviveNew;

%========================
% Constraints
%========================
% Initial Old workforce in year 1 equals given Strength (all >1 year service)
constraint forall(k in 1..K)(
  Old[k,1] = Strength[k]
);

% Recruitment bounds per year
constraint forall(k in 1..K, t in 1..I)(
  New[k,t] <= Recruit[k]
);

% Redundancy cannot exceed Old
constraint forall(k in 1..K, t in 1..I)(
  Redundant[k,t] <= Old[k,t]
);

% Short-time workers cannot exceed available (after redundancies)
constraint forall(k in 1..K, t in 1..I)(
  Short[k,t] <= Old[k,t] + New[k,t] - Redundant[k,t]
);

% Wastage and workforce evolution (scaled to avoid fractions):
% SurviveOld = (Old - Redundant) * (1 - wMore)
% SurviveNew = New * (1 - wLess)
constraint forall(k in 1..K, t in 1..I)(
  SurviveOld[k,t] * SCALE = (Old[k,t] - Redundant[k,t]) * (SCALE - wMore[k])
);

constraint forall(k in 1..K, t in 1..I)(
  SurviveNew[k,t] * SCALE = New[k,t] * (SCALE - wLess[k])
);

% Next year Old becomes survivors from previous year
constraint forall(k in 1..K, t in 1..I-1)(
  Old[k,t+1] = SurviveOld[k,t] + SurviveNew[k,t]
);

% Production requirement satisfaction:
% Effective full-time equivalents = (Old+New-Redundant-Short) + 0.5*Short
% => Effective = Old+New-Redundant - 0.5*Short
% Must be at least Requirement, allowing overmanning Over:
% Effective = Requirement + Over
constraint forall(k in 1..K, t in 1..I)(
  2*(Old[k,t] + New[k,t] - Redundant[k,t]) - Short[k,t]
  = 2*Requirement[k,t] + 2*Over[k,t]
);

% Company-wide caps per year
constraint forall(t in 1..I)(
  sum(k in 1..K)(Over[k,t]) <= NumOverman
);

constraint forall(t in 1..I)(
  sum(k in 1..K)(Short[k,t]) <= NumShortwork
);

%========================
% Objective: minimize total cost
% - redundancy payments
% - overmanning yearly costs
% - short-time yearly costs
% (No explicit recruitment cost given in data.)
%========================
var int: TotalRedundancyCost =
  sum(k in 1..K, t in 1..I)(CostRedundancy[k] * Redundant[k,t]);

var int: TotalOvermanCost =
  sum(k in 1..K, t in 1..I)(CostOverman[k] * Over[k,t]);

var int: TotalShortCost =
  sum(k in 1..K, t in 1..I)(CostShort[k] * Short[k,t]);

var int: TotalCost = TotalRedundancyCost + TotalOvermanCost + TotalShortCost;

solve minimize TotalCost;

%========================
% Output
%========================
output [
  "TotalCost=", show(TotalCost), "\n",
  "TotalRedundancyCost=", show(TotalRedundancyCost), "\n",
  "TotalOvermanCost=", show(TotalOvermanCost), "\n",
  "TotalShortCost=", show(TotalShortCost), "\n\n",
  "Old=\n", show(Old), "\n\n",
  "New=\n", show(New), "\n\n",
  "Redundant=\n", show(Redundant), "\n\n",
  "Short=\n", show(Short), "\n\n",
  "Over=\n", show(Over), "\n"
];