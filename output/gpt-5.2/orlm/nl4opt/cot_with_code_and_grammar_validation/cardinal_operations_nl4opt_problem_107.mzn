% Parameters
int: nFarms = 2;
set of int: FARMS = 1..nFarms;

int: nBerries = 3;
set of int: BERRIES = 1..nBerries;

% Berry indices: 1=raspberries, 2=blueberries, 3=strawberries
array[FARMS] of int: cost_per_day = [300, 200];

array[BERRIES] of int: demand = [10, 9, 15];

% yield[f,b] = kg of berry b produced per day at farm f
array[FARMS, BERRIES] of int: yield =
  array2d(FARMS, BERRIES,
    [ 2, 2, 4,   % old farm
      4, 1, 2    % new farm
    ]);

% Upper bounds for operating days (safe finite bounds derived from demands and positive yields)
int: UB_old =
  max([ (demand[b] + yield[1,b] - 1) div yield[1,b] | b in BERRIES ]);
int: UB_new =
  max([ (demand[b] + yield[2,b] - 1) div yield[2,b] | b in BERRIES ]);

% Variables
var 0..UB_old: days_old;
var 0..UB_new: days_new;

% Constraints
constraint
  forall(b in BERRIES) (
    yield[1,b] * days_old + yield[2,b] * days_new >= demand[b]
  );

% Objective
solve minimize cost_per_day[1] * days_old + cost_per_day[2] * days_new;