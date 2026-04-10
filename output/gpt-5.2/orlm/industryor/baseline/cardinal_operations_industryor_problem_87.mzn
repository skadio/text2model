% MiniZinc LP model: maximize total ending inventory (liquid + solid)

% ----- Data (embedded) -----
set of int: P = 1..2; % 1=liquid, 2=solid

array[P] of string: pname = ["liquid","solid"];

% Processing times (minutes per lot)
array[P] of int: t1 = [50, 24]; % Machine 1
array[P] of int: t2 = [30, 33]; % Machine 2

% Initial inventories (lots)
array[P] of float: initInv = [30.0, 90.0];

% Demand (lots)
array[P] of float: demand = [75.0, 95.0];

% Available machine time (minutes)
float: M1_avail = 40.0 * 60.0; % 40 hours
float: M2_avail = 35.0 * 60.0; % 35 hours

% ----- Decision variables -----
array[P] of var float: prod;     % lots produced (can be fractional, nonnegative)
array[P] of var float: endInv;   % ending inventory (nonnegative)

% ----- Constraints -----
constraint forall(p in P) (
  endInv[p] = initInv[p] + prod[p] - demand[p]
);

constraint forall(p in P) (prod[p] >= 0.0);
constraint forall(p in P) (endInv[p] >= 0.0);

constraint sum(p in P) (t1[p] * prod[p]) <= M1_avail;
constraint sum(p in P) (t2[p] * prod[p]) <= M2_avail;

% ----- Objective -----
solve maximize sum(p in P) (endInv[p]);

% ----- Output -----
output [
  "Production (lots):\n",
  "  liquid = ", show(prod[1]), "\n",
  "  solid  = ", show(prod[2]), "\n\n",
  "Ending inventory (lots):\n",
  "  liquid = ", show(endInv[1]), "\n",
  "  solid  = ", show(endInv[2]), "\n\n",
  "Total ending inventory = ", show(sum(p in P)(endInv[p])), "\n"
];