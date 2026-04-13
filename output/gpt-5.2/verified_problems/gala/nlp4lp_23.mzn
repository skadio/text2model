include "globals.mzn";

%========================
% Input data (from .dzn)
%========================
int: K;                          % number of worker categories (e.g., 3)
int: I;                          % number of years (e.g., 3)

array[1..K, 1..I] of int: Requirement;   % required effective manpower by category & year

array[1..K] of int: Strength;            % initial workforce (all have >1 year service)
array[1..K] of float: LessOneWaste;      % wastage rate for <1 year service (new recruits)
array[1..K] of float: MoreOneWaste;      % wastage rate for >1 year service (existing/older)

array[1..K] of int: Recruit;             % max recruits per category per year

array[1..K] of int: CostRedundancy;      % redundancy cost per worker by category
int: NumOverman;                         % max total overmanning (headcount) across company
array[1..K] of int: CostOverman;         % cost per extra (overmanned) worker by category per year

int: NumShortwork;                       % max total short-time workers across company per year
array[1..K] of int: CostShort;           % cost per short-time worker by category per year

%========================
% Decision variables
%========================
% recruits, redundancies, and short-time working by category and year
array[1..K, 1..I] of var 0..max(Recruit): recruit;
array[1..K, 1..I] of var 0..(max(Strength) + I*max(Recruit)): redund;
array[1..K, 1..I] of var 0..(max(Strength) + I*max(Recruit)): short;

% workforce headcount at end of each year (after decisions and wastage)
array[1..K, 0..I] of var 0..(max(Strength) + I*max(Recruit)): head;
constraint forall(k in 1..K)( head[k,0] = Strength[k] );

% overmanning slack (headcount above the (effective) requirement)
array[1..K, 1..I] of var 0..(max(Strength) + I*max(Recruit)): over;

%========================
% Helper constants
%========================
int: SCALE = 1000;  % scaling to avoid floating vars
array[1..K] of int: wNew  = [ round((1.0 - LessOneWaste[k]) * SCALE) | k in 1..K ];
array[1..K] of int: wOld  = [ round((1.0 - MoreOneWaste[k]) * SCALE) | k in 1..K ];

%========================
% Core constraints
%========================

% Recruitment limits
constraint forall(k in 1..K, t in 1..I)(
  recruit[k,t] <= Recruit[k]
);

% Short-time working limit across company each year
constraint forall(t in 1..I)(
  sum(k in 1..K)( short[k,t] ) <= NumShortwork
);

% Short-time cannot exceed available workforce (after actions, before wastage)
% (We apply it as a policy decision on that year's headcount level.)
constraint forall(k in 1..K, t in 1..I)(
  short[k,t] <= head[k,t-1] + recruit[k,t] - redund[k,t]
);

% Workforce evolution with wastage:
% - all existing workforce at start of year has "old" wastage (MoreOneWaste)
% - all recruits this year have "new" wastage (LessOneWaste)
% - redundancies are assumed to be removed before wastage is realized
constraint forall(k in 1..K, t in 1..I)(
  head[k,t] * SCALE =
      (head[k,t-1] - redund[k,t]) * wOld[k] + recruit[k,t] * wNew[k]
);

% Effective manpower delivered considering short-time:
% short-time workers contribute half (0.5) of a full-time equivalent.
% Also allow overmanning up to NumOverman in total headcount above requirements.
constraint forall(k in 1..K, t in 1..I)(
  (head[k,t] * 2 - short[k,t]) >= 2 * Requirement[k,t]  % effective >= required
);

% Define overmanning as headcount exceeding requirement (ignoring short-time FTE),
% but only charge/cap it for "extra people" the company keeps.
constraint forall(k in 1..K, t in 1..I)(
  over[k,t] >= head[k,t] - Requirement[k,t] /\
  over[k,t] >= 0
);

constraint forall(t in 1..I)(
  sum(k in 1..K)( over[k,t] ) <= NumOverman
);

%========================
% Objective: minimize redundancy (declared objective)
% Secondary costs included to break ties (optional but sensible):
%  - overmanning cost
%  - short-time working cost
%========================
var int: totalRedCost = sum(k in 1..K, t in 1..I)( CostRedundancy[k] * redund[k,t] );
var int: totalOverCost = sum(k in 1..K, t in 1..I)( CostOverman[k] * over[k,t] );
var int: totalShortCost = sum(k in 1..K, t in 1..I)( CostShort[k] * short[k,t] );

solve minimize totalRedCost * 1000000 + totalOverCost + totalShortCost;

%========================
% Output
%========================
output [
  "TotalRedundancyCost = ", show(totalRedCost), "\n",
  "TotalOvermanCost    = ", show(totalOverCost), "\n",
  "TotalShortCost      = ", show(totalShortCost), "\n\n",
  "Recruit (k x t) =\n", show(recruit), "\n\n",
  "Redund (k x t)  =\n", show(redund), "\n\n",
  "Short (k x t)   =\n", show(short), "\n\n",
  "Headcount end-of-year (k x t, t=0..I) =\n", show(head), "\n\n",
  "Over (k x t)    =\n", show(over), "\n"
];