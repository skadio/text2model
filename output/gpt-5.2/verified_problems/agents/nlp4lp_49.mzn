% Parameters
int: A; % total number of different alloys
int: S; % total number of different steel types

set of int: ALLOYS = 1..A; % index set for alloys
set of int: STEELS = 1..S; % index set for steel types

array[ALLOYS] of float: AvailableAlloy;  % available amount (tons) of alloy a
array[ALLOYS] of float: CarbonContent;   % carbon percentage/content of alloy a
array[ALLOYS] of float: NickelContent;   % nickel percentage/content of alloy a
array[ALLOYS] of float: AlloyPrice;      % purchase price per ton of alloy a

array[STEELS] of float: SteelPrice;      % selling price per ton of steel type s
array[STEELS] of float: CarbonMin;       % minimum required carbon content for steel type s
array[STEELS] of float: NickelMax;       % maximum allowed nickel content for steel type s

% Helpful derived bound (used only for variable upper bounds)
float: TotalAvailableAlloy = sum(a in ALLOYS)(AvailableAlloy[a]); % total alloy available (tons)

% Variables
array[ALLOYS, STEELS] of var float: UseAlloyInSteel; % tons of alloy a used in steel s
array[STEELS] of var float: ProduceSteel;            % tons of steel type s produced

% Constraints
% --- Variable bounds (as constraints; avoids float-in-domain issues) ---
constraint forall(a in ALLOYS, s in STEELS) (
  UseAlloyInSteel[a,s] >= 0.0 /\ UseAlloyInSteel[a,s] <= AvailableAlloy[a]
);

constraint forall(s in STEELS) (
  ProduceSteel[s] >= 0.0 /\ ProduceSteel[s] <= TotalAvailableAlloy
);

% --- Steel mass balance: produced tons equal sum of alloy tons used in that steel ---
constraint forall(s in STEELS) (
  ProduceSteel[s] = sum(a in ALLOYS)(UseAlloyInSteel[a,s])
);

% --- Alloy availability: cannot use more of an alloy than is available across all steels ---
constraint forall(a in ALLOYS) (
  sum(s in STEELS)(UseAlloyInSteel[a,s]) <= AvailableAlloy[a]
);

% --- Carbon minimum requirement per steel (weighted-average constraint) ---
% sum_a (Use[a,s] * CarbonContent[a]) >= CarbonMin[s] * ProduceSteel[s]
constraint forall(s in STEELS) (
  sum(a in ALLOYS)(UseAlloyInSteel[a,s] * CarbonContent[a])
    >= CarbonMin[s] * ProduceSteel[s]
);

% --- Nickel maximum requirement per steel (weighted-average constraint) ---
% sum_a (Use[a,s] * NickelContent[a]) <= NickelMax[s] * ProduceSteel[s]
constraint forall(s in STEELS) (
  sum(a in ALLOYS)(UseAlloyInSteel[a,s] * NickelContent[a])
    <= NickelMax[s] * ProduceSteel[s]
);

% --- Composition restriction: at most 40% of alloy 1 in any steel ---
% UseAlloyInSteel[1,s] <= 0.4 * ProduceSteel[s]
constraint forall(s in STEELS) (
  UseAlloyInSteel[1,s] <= 0.4 * ProduceSteel[s]
);

% Objective
solve maximize
  sum(s in STEELS)(SteelPrice[s] * ProduceSteel[s])
  - sum(a in ALLOYS, s in STEELS)(AlloyPrice[a] * UseAlloyInSteel[a,s]);