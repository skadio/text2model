% Parameters
int: A; % number of different alloys
int: S; % number of different steel types

set of int: ALLOYS = 1..A;
set of int: STEELS = 1..S;

array[ALLOYS] of float: AvailableAlloy;  % available amount (tons) of each alloy a
array[ALLOYS] of float: CarbonContent;   % carbon % in alloy a
array[ALLOYS] of float: NickelContent;   % nickel % in alloy a
array[ALLOYS] of float: AlloyPrice;      % purchase price per ton of alloy a

array[STEELS] of float: SteelPrice;      % selling price per ton of steel type s
array[STEELS] of float: CarbonMin;       % minimum required carbon % for steel type s
array[STEELS] of float: NickelMax;       % maximum allowed nickel % for steel type s

% A safe big-M upper bound for produced steel (total available alloy)
float: TotalAlloyAvail = sum(a in ALLOYS)(AvailableAlloy[a]);

% Variables (use bounded float vars to avoid solver limit errors)
array[ALLOYS, STEELS] of var 0.0..TotalAlloyAvail: UseAlloyInSteel; % tons of alloy a used in steel type s
array[STEELS] of var 0.0..TotalAlloyAvail: ProduceSteel;            % tons of steel type s produced

% Constraints
% ---- Alloy availability: cannot use more of an alloy than available ----
constraint
  forall(a in ALLOYS) (
    sum(s in STEELS)(UseAlloyInSteel[a,s]) <= AvailableAlloy[a]
  );

% ---- Steel mass balance: produced steel equals sum of alloys used in it ----
constraint
  forall(s in STEELS) (
    sum(a in ALLOYS)(UseAlloyInSteel[a,s]) = ProduceSteel[s]
  );

% ---- Carbon requirement: weighted average carbon >= minimum required ----
constraint
  forall(s in STEELS) (
    sum(a in ALLOYS)(UseAlloyInSteel[a,s] * CarbonContent[a])
      >= CarbonMin[s] * ProduceSteel[s]
  );

% ---- Nickel limit: weighted average nickel <= maximum allowed ----
constraint
  forall(s in STEELS) (
    sum(a in ALLOYS)(UseAlloyInSteel[a,s] * NickelContent[a])
      <= NickelMax[s] * ProduceSteel[s]
  );

% ---- Composition limit: at most 40% of alloy 1 in any steel type ----
constraint
  forall(s in STEELS) (
    UseAlloyInSteel[1,s] <= 0.4 * ProduceSteel[s]
  );

% Objective (maximize profit)
solve maximize
  sum(s in STEELS)(SteelPrice[s] * ProduceSteel[s])
  - sum(a in ALLOYS, s in STEELS)(AlloyPrice[a] * UseAlloyInSteel[a,s]);