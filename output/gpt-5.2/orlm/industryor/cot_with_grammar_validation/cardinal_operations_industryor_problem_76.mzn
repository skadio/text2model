int: N = 10;
set of int: PARTS = 1..N;
set of int: MACHINES = 1..3;

array[MACHINES, PARTS] of int: unit_cost =
  array2d(MACHINES, PARTS,
    [ 10,  20,  30,  40,  50,  60,  70,  80,  90, 100,
      15,  25,  35,  45,  55,  65,  75,  85,  95, 105,
      20,  30,  40,  50,  60,  70,  80,  90, 100, 110 ]
  );

array[MACHINES] of int: setup_cost = [100, 135, 200];

array[PARTS] of var MACHINES: m;
array[MACHINES] of var bool: use_machine;

var int: total_cost;

constraint m[3] = 1;
constraint m[4] = 2;
constraint m[5] = 3;

constraint (m[1] = 1 /\ (m[2] = 2 \/ m[2] = 3))
        \/ ((m[1] = 2 \/ m[1] = 3) /\ m[2] = 1);

constraint forall(k in MACHINES) (
  use_machine[k] <-> exists(p in PARTS) (m[p] = k)
);

constraint sum(p in PARTS)(bool2int(m[p] = 3)) <= 3;

constraint total_cost =
  sum(p in PARTS)(unit_cost[m[p], p]) +
  sum(k in MACHINES)(setup_cost[k] * bool2int(use_machine[k]));

solve minimize total_cost;