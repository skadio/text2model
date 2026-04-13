% Transportation of empty containers from warehouses to ports
% Minimize total transport cost.
% Cost is proportional to distance at 30 EUR/km per container.
% Trucks capacity: 2 containers (modeled via integer number of trucks per lane).

int: rate = 30;               % EUR per km per container
int: truck_capacity = 2;

set of int: W = 1..6;
set of int: P = 1..5;

array[W] of string: wname = ["Verona","Perugia","Rome","Pescara","Taranto","Lamezia"];
array[P] of string: pname = ["Genoa","Venice","Ancona","Naples","Bari"];

array[W] of int: supply = [10, 12, 20, 24, 18, 40];
array[P] of int: demand = [20, 15, 25, 33, 21];

array[W, P] of int: dist =
  [| 290,  115, 355, 715, 810
   | 380,  340, 165, 380, 610
   | 505,  530, 285, 220, 450
   | 655,  450, 155, 240, 315
   |1010,  840, 550, 305,  95
   |1072, 1097, 747, 372, 333 |];

% Decision variables
% x[w,p] = containers shipped from warehouse w to port p
array[W, P] of var 0..max(supply): x;

% t[w,p] = number of trucks used on lane (w,p)
array[W, P] of var 0..max(supply): t;

% Supply constraints (cannot ship more than available)
constraint forall(w in W)(
  sum(p in P)(x[w,p]) <= supply[w]
);

% Demand constraints (must meet demand exactly)
constraint forall(p in P)(
  sum(w in W)(x[w,p]) = demand[p]
);

% Truck capacity constraints: each truck carries up to 2 containers
constraint forall(w in W, p in P)(
  x[w,p] <= truck_capacity * t[w,p]
);

% Objective: total cost per container-km
var int: total_cost = sum(w in W, p in P)(rate * dist[w,p] * x[w,p]);

solve minimize total_cost;

output [
  "Total cost (EUR): ", show(total_cost), "\n\n",
  "Shipments x[w,p] (containers):\n"
]
++
[
  wname[w] ++ " -> " ++ pname[p] ++ ": " ++ show(x[w,p]) ++
  "  (trucks: " ++ show(t[w,p]) ++ ")\n"
  | w in W, p in P
];