% Parameters
array[1..3] of int: Strength;
array[1..3] of float: LessOneWaste;
array[1..3] of float: MoreOneWaste;
array[1..3] of int: Recruit;
array[1..3] of int: CostRedundancy;
int: NumOverman;
array[1..3] of int: CostOverman;
int: NumShortwork;
array[1..3] of int: CostShort;
array[1..3, 1..3] of int: Requirement;

% Variables
array[1..3, 1..3] of var int: Employed;
array[1..3, 1..3] of var int: Recruited;
array[1..3, 1..3] of var int: Redundant;
array[1..3, 1..3] of var int: Shortworked;
array[1..3, 1..3] of var int: Overmanned;

% Constraints
constraint
  forall(k in 1..3, t in 1..3) (
    Employed[k,t] >= 0 /\ Recruited[k,t] >= 0 /\ Redundant[k,t] >= 0 /\ Shortworked[k,t] >= 0 /\ Overmanned[k,t] >= 0
  );

% Recruitment limits
constraint
  forall(k in 1..3) (
    sum(t in 1..3)(Recruited[k,t]) <= Recruit[k]
  );

% Short‑work limits per category
constraint
  forall(k in 1..3) (
    sum(t in 1..3)(Shortworked[k,t]) <= NumShortwork
  );

% Total over‑man limit
constraint
  sum(k in 1..3, t in 1..3)(Overmanned[k,t]) <= NumOverman;

% Requirement satisfaction (full‑time + half of short‑worked)
constraint
  forall(k in 1..3, t in 1..3) (
    2 * Employed[k,t] + Shortworked[k,t] >= 2 * Requirement[k,t]
  );

% Workforce dynamics
constraint
  forall(k in 1..3) (
    Employed[k,1] = Requirement[k,1] + Recruited[k,1] - Redundant[k,1] - Shortworked[k,1] + Overmanned[k,1]
  ) /\
  forall(k in 1..3, t in 2..3) (
    Employed[k,t] = Employed[k,t-1] + Recruited[k,t] - Redundant[k,t] - Shortworked[k,t] + Overmanned[k,t]
  );

% Objective
solve minimize
  sum(k in 1..3, t in 1..3)(CostRedundancy[k] * Redundant[k,t]);