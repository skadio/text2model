% Berry farm operating plan (LP) - minimize total cost

% Sets
set of int: FARMS = 1..2;      % 1 = old, 2 = new
set of int: BERRIES = 1..3;    % 1 = raspberry, 2 = blueberry, 3 = strawberry

% Data (embedded)
array[BERRIES] of float: demandKg = [10.0, 9.0, 15.0];
array[FARMS]  of float: costPerDay = [300.0, 200.0];

% yieldKgPerDay[farm, berry]
array[FARMS, BERRIES] of float: yieldKgPerDay =
  array2d(FARMS, BERRIES,
    [ 2.0, 2.0, 4.0,   % old farm
      4.0, 1.0, 2.0    % new farm
    ]);

% Decision variables: operating days at each farm (continuous, nonnegative)
array[FARMS] of var float: daysOperate;

% Constraints: meet or exceed demand for each berry
constraint forall(b in BERRIES) (
  sum(f in FARMS) (yieldKgPerDay[f,b] * daysOperate[f]) >= demandKg[b]
);

% Objective: minimize total operating cost
var float: totalCost = sum(f in FARMS) (costPerDay[f] * daysOperate[f]);

solve minimize totalCost;