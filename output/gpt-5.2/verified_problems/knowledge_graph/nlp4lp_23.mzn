include "globals.mzn";

%--------------------------
% Sets / dimensions
%--------------------------
int: K; % number of worker categories
int: I; % number of years / planning periods

set of int: R = 1..K;
set of int: T = 1..I;

%--------------------------
% Input data (from .dzn)
%--------------------------
array[R, T] of int: Requirement;          % required effective manpower by category and year
array[R] of int: Strength;                % initial workforce (all have > 1 year service)

array[R] of float: LessOneWaste;          % wastage rate for recruits (< 1 year service)
array[R] of float: MoreOneWaste;          % wastage rate for experienced (>= 1 year service)

array[R] of int: Recruit;                 % max recruits per category per year

array[R] of int: CostRedundancy;          % redundancy cost per employee
int: NumOverman;                          % max total overmanning across company (each year)
array[R] of int: CostOverman;             % overmanning cost per employee per year

int: NumShortwork;                        % max total short-time workers across company (each year)
array[R] of int: CostShort;               % short-time working cost per employee per year

%--------------------------
% Decision variables
%--------------------------
% Workforce split at start of each year t:
%   Exp[r,t] = experienced workers (>= 1 year service) available at start of year t
%   New[r,t] = workers with < 1 year service (i.e., recruited in year t)
array[R, T] of var 0..sum(Strength)+I*max(Recruit): Exp;
array[R, T] of var 0..max(Recruit): New;

% Decisions each year
array[R, T] of var 0..max(Recruit): Rec;                         % recruited in year t
array[R, T] of var 0..sum(Strength)+I*max(Recruit): Red;          % redundancies applied at start of year t
array[R, T] of var 0..NumOverman: Over;                           % overmanning (extra full-time equiv) in year t
array[R, T] of var 0..NumShortwork: Short;                        % short-time workers in year t (count of people)

% Derived: effective manpower delivered in year t
array[R, T] of var 0..sum(Strength)+I*max(Recruit): Eff;

%--------------------------
% Core dynamics
%--------------------------
% Year 1 start: all initial workers are experienced; no "new" unless recruited in year 1.
constraint forall(r in R) (
  Exp[r,1] = Strength[r]
);

constraint forall(r in R, t in T) (
  New[r,t] = Rec[r,t]
);

% Workforce evolution:
% After year t, some experienced workers leave (MoreOneWaste),
% some new workers leave (LessOneWaste), and surviving new become experienced next year.
constraint forall(r in R, t in 1..I-1) (
  Exp[r,t+1] =
      round((1.0 - MoreOneWaste[r]) * int2float(Exp[r,t] - Red[r,t]))
    + round((1.0 - LessOneWaste[r]) * int2float(New[r,t]))
);

% Recruitment bounds
constraint forall(r in R, t in T) (
  Rec[r,t] <= Recruit[r]
);

% Redundancy cannot exceed experienced available at start of year
constraint forall(r in R, t in T) (
  Red[r,t] <= Exp[r,t]
);

%--------------------------
% Meeting requirements with overmanning and short-time working
%--------------------------
% Effective manpower provided in year t:
% full-time equiv = (experienced after redundancy) + (new hires) - (short-time half-loss) = ... - 0.5*Short
constraint forall(r in R, t in T) (
  Eff[r,t] = (Exp[r,t] - Red[r,t]) + New[r,t] - (Short[r,t] div 2)
);

% Requirements can be met by allowing overmanning (extra above requirement) and short-time (counts as half)
% Here we enforce: Eff + Over >= Requirement
constraint forall(r in R, t in T) (
  Eff[r,t] + Over[r,t] >= Requirement[r,t]
);

% Overmanning limited across company each year
constraint forall(t in T) (
  sum(r in R)(Over[r,t]) <= NumOverman
);

% Short-time working limited across company each year
constraint forall(t in T) (
  sum(r in R)(Short[r,t]) <= NumShortwork
);

% Also cannot short-work more people than are employed that year
constraint forall(r in R, t in T) (
  Short[r,t] <= (Exp[r,t] - Red[r,t]) + New[r,t]
);

%--------------------------
% Objective: minimize redundancy (declared objective)
% Tie-breaker: small penalty on overmanning and short-time working costs (optional but keeps solutions sensible)
%--------------------------
var int: TotalRed = sum(r in R, t in T)(Red[r,t]);
var int: TotalOverCost = sum(r in R, t in T)(Over[r,t] * CostOverman[r]);
var int: TotalShortCost = sum(r in R, t in T)(Short[r,t] * CostShort[r]);

solve minimize TotalRed * 1000000 + TotalOverCost + TotalShortCost;

%--------------------------
% Output
%--------------------------
output [
  "TotalRed=", show(TotalRed), "\n",
  "Rec=\n", show(Rec), "\n",
  "Red=\n", show(Red), "\n",
  "Over=\n", show(Over), "\n",
  "Short=\n", show(Short), "\n",
  "Exp=\n", show(Exp), "\n"
];