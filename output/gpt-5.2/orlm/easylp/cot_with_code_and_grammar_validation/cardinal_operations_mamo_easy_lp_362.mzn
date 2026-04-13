% Parameters
int: nFields = 4;
set of int: FIELDS = 1..nFields;

array[FIELDS] of int: area = [150, 200, 100, 250]; % acres per field (whole numbers)

set of int: CROPS = 1..4;
int: CORN = 1;
int: WHEAT = 2;
int: SOYBEAN = 3;
int: RICE = 4;

array[CROPS] of int: cost = [3, 2, 5, 4]; % $ per acre

int: maxCereal = 500;      % Corn + Wheat area upper bound
int: maxWater = 400;       % Soybean + Rice area upper bound
int: minLegumes = 200;     % Corn + Soybean area lower bound (as stated)
int: minGrains = 300;      % Wheat + Rice area lower bound

% Variables
array[FIELDS] of var CROPS: crop;  % crop planted in each field
var 0..sum(area): totalCost;

% Constraints
constraint
  totalCost = sum(f in FIELDS)( area[f] * cost[crop[f]] );

constraint
  sum(f in FIELDS)( area[f] * bool2int(crop[f] = CORN) )
+ sum(f in FIELDS)( area[f] * bool2int(crop[f] = WHEAT) )
<= maxCereal;

constraint
  sum(f in FIELDS)( area[f] * bool2int(crop[f] = SOYBEAN) )
+ sum(f in FIELDS)( area[f] * bool2int(crop[f] = RICE) )
<= maxWater;

constraint
  sum(f in FIELDS)( area[f] * bool2int(crop[f] = CORN) )
+ sum(f in FIELDS)( area[f] * bool2int(crop[f] = SOYBEAN) )
>= minLegumes;

constraint
  sum(f in FIELDS)( area[f] * bool2int(crop[f] = WHEAT) )
+ sum(f in FIELDS)( area[f] * bool2int(crop[f] = RICE) )
>= minGrains;

% Objective
solve minimize totalCost;