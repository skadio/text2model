% Parameters (with values embedded)
int: nFarms = 2;
set of int: FARMS = 1..nFarms;
int: OLD = 1;
int: NEW = 2;

int: nBerries = 3;
set of int: BERRIES = 1..nBerries;
int: RASP = 1;
int: BLUE = 2;
int: STRAW = 3;

array[FARMS] of int: cost_per_day = [300, 200];

% yield[farm, berry] in kg per day
array[FARMS, BERRIES] of int: yield = 
  array2d(FARMS, BERRIES,
    [ 2, 2, 4,   % old farm: rasp, blue, straw
      4, 1, 2    % new farm: rasp, blue, straw
    ]);

array[BERRIES] of int: demand = [10, 9, 15];

% Upper bounds on days (safe small bounds from demands and positive yields)
array[FARMS] of int: ub_days = [
  max([ (demand[b] + yield[OLD,b] - 1) div yield[OLD,b] | b in BERRIES ]),
  max([ (demand[b] + yield[NEW,b] - 1) div yield[NEW,b] | b in BERRIES ])
];

% Variables
array[FARMS] of var 0..max(ub_days): days;

% Constraints
constraint forall(b in BERRIES) (
  sum(f in FARMS)(yield[f,b] * days[f]) >= demand[b]
);

% Objective
solve minimize sum(f in FARMS)(cost_per_day[f] * days[f]);