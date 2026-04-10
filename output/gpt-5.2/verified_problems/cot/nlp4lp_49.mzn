% Parameters
int: A;
int: S;

set of int: ALLOYS = 1..A;
set of int: STEELS = 1..S;

array[ALLOYS] of float: AvailableAlloy;
array[ALLOYS] of float: CarbonContent;
array[ALLOYS] of float: NickelContent;
array[ALLOYS] of float: AlloyPrice;

array[STEELS] of float: SteelPrice;
array[STEELS] of float: CarbonMin;
array[STEELS] of float: NickelMax;

% Variables
array[ALLOYS, STEELS] of var float: Use;     % tons of alloy a used in steel s
array[STEELS] of var float: Produce;         % tons of steel s produced

% Constraints
constraint
  forall(a in ALLOYS, s in STEELS) (
    Use[a,s] >= 0.0
  );

constraint
  forall(s in STEELS) (
    Produce[s] >= 0.0
  );

% Link steel production to alloy usage (mass balance)
constraint
  forall(s in STEELS) (
    Produce[s] = sum(a in ALLOYS)(Use[a,s])
  );

% Alloy availability limits
constraint
  forall(a in ALLOYS) (
    sum(s in STEELS)(Use[a,s]) <= AvailableAlloy[a]
  );

% Carbon minimum requirements per steel type
constraint
  forall(s in STEELS) (
    sum(a in ALLOYS)(CarbonContent[a] * Use[a,s]) >= CarbonMin[s] * Produce[s]
  );

% Nickel maximum requirements per steel type
constraint
  forall(s in STEELS) (
    sum(a in ALLOYS)(NickelContent[a] * Use[a,s]) <= NickelMax[s] * Produce[s]
  );

% At most 40% of alloy 1 in any steel type
constraint
  forall(s in STEELS) (
    Use[1,s] <= 0.4 * Produce[s]
  );

% Objective
solve maximize
  sum(s in STEELS)(SteelPrice[s] * Produce[s])
  - sum(a in ALLOYS, s in STEELS)(AlloyPrice[a] * Use[a,s]);