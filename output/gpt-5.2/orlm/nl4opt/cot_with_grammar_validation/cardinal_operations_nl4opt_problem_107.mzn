int: nFarms = 2;
set of int: FARMS = 1..nFarms;

int: nBerries = 3;
set of int: BERRIES = 1..nBerries;

array[FARMS] of int: cost_per_day = [300, 200];
array[BERRIES] of int: demand = [10, 9, 15];

array[FARMS, BERRIES] of int: yield =
  array2d(FARMS, BERRIES,
    [ 2, 2, 4,
      4, 1, 2
    ]
  );

array[FARMS] of int: max_days = [1000, 1000];

array[FARMS] of var 0..1000: days;

constraint
  forall(b in BERRIES) (
    sum(f in FARMS) (yield[f, b] * days[f]) >= demand[b]
  );

solve minimize sum(f in FARMS) (cost_per_day[f] * days[f]);

output [
  "days_old=", show(days[1]), "\n",
  "days_new=", show(days[2]), "\n",
  "total_cost=", show(sum(f in FARMS) (cost_per_day[f] * days[f])), "\n"
];