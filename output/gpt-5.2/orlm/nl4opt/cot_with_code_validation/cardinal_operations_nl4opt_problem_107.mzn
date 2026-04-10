% Parameters
int: nFarms = 2;
set of int: FARMS = 1..nFarms;
int: nBerries = 3;
set of int: BERRIES = 1..nBerries;

% Index mapping: 1=raspberries, 2=blueberries, 3=strawberries
array[FARMS] of int: cost = [300, 200];

array[FARMS, BERRIES] of int: yield = 
  array2d(FARMS, BERRIES,
    [ 2, 2, 4,   % old farm
      4, 1, 2    % new farm
    ]);

array[BERRIES] of int: demand = [10, 9, 15];

% Variables
array[FARMS] of var 0..1000: days;

% Constraints
constraint
  forall(b in BERRIES) (
    sum(f in FARMS) (yield[f,b] * days[f]) >= demand[b]
  );

% Objective
solve minimize sum(f in FARMS) (cost[f] * days[f]);