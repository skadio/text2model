% Parameters
int: A;
int: S;

set of int: Alloys = 1..A;
set of int: Steels = 1..S;

array[Alloys] of float: AvailableAlloy;
array[Alloys] of float: CarbonContent;
array[Alloys] of float: NickelContent;
array[Alloys] of float: AlloyPrice;

array[Steels] of float: SteelPrice;
array[Steels] of float: CarbonMin;
array[Steels] of float: NickelMax;

float: TotalAvailableAlloy = sum(a in Alloys)(AvailableAlloy[a]);

% Variables
array[Alloys, Steels] of var 0.0..TotalAvailableAlloy: Use;              % tons of alloy a in steel s
array[Steels]            of var 0.0..TotalAvailableAlloy: SteelProduced; % tons of steel s

% Constraints
constraint
  forall(a in Alloys)(
    sum(s in Steels)(Use[a,s]) <= AvailableAlloy[a]
  );

constraint
  forall(s in Steels)(
    SteelProduced[s] = sum(a in Alloys)(Use[a,s])
  );

constraint
  forall(s in Steels)(
    sum(a in Alloys)(CarbonContent[a] * Use[a,s]) >= CarbonMin[s] * SteelProduced[s]
  );

constraint
  forall(s in Steels)(
    sum(a in Alloys)(NickelContent[a] * Use[a,s]) <= NickelMax[s] * SteelProduced[s]
  );

constraint
  forall(s in Steels)(
    Use[1,s] <= 0.4 * SteelProduced[s]      % Max 40% of alloy 1 in any steel
  );

% Objective
var float: Profit = 
    sum(s in Steels)(SteelPrice[s] * SteelProduced[s]) 
  - sum(a in Alloys, s in Steels)(AlloyPrice[a] * Use[a,s]);

solve maximize Profit;