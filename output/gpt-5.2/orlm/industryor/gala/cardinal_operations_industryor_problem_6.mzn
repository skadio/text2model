include "globals.mzn";

% Transportation of empty containers from warehouses to ports
% Minimize cost = 30 EUR/km per container shipped.
% Each truck carries up to 2 containers, so #trucks = ceil(containers/2) per route.

% ----- Sets -----
int: W = 6;
int: P = 5;
set of int: Warehouses = 1..W;
set of int: Ports = 1..P;

% ----- Data (embedded) -----
array[Warehouses] of string: wName =
  ["Verona","Perugia","Rome","Pescara","Taranto","Lamezia"];
array[Ports] of string: pName =
  ["Genoa","Venice","Ancona","Naples","Bari"];

array[Warehouses] of int: supply = [10,12,20,24,18,40];
array[Ports] of int: demand = [20,15,25,33,21];

array[Warehouses, Ports] of int: dist_km =
  [|  290,  115,  355,  715,  810   % Verona
   |  380,  340,  165,  380,  610   % Perugia
   |  505,  530,  285,  220,  450   % Rome
   |  655,  450,  155,  240,  315   % Pescara
   | 1010,  840,  550,  305,   95   % Taranto
   | 1072, 1097,  747,  372,  333   % Lamezia
  |];

int: rate_eur_per_km = 30;

% ----- Decision variables -----
% x[w,p] = number of containers shipped from warehouse w to port p
array[Warehouses, Ports] of var 0..max(supply): x;

% trucks[w,p] = number of trucks used on route (w,p)
% capacity 2 => trucks >= ceil(x/2) implemented via: 2*trucks >= x and x <= 2*trucks
array[Warehouses, Ports] of var 0..max(supply): trucks;

% ----- Constraints -----
% Supply limits
constraint forall(w in Warehouses)(
  sum(p in Ports)(x[w,p]) <= supply[w]
);

% Demand satisfaction (must meet exactly)
constraint forall(p in Ports)(
  sum(w in Warehouses)(x[w,p]) = demand[p]
);

% Truck capacity (each truck can carry up to 2 containers)
constraint forall(w in Warehouses, p in Ports)(
  x[w,p] <= 2 * trucks[w,p] /\
  2 * trucks[w,p] >= x[w,p]
);

% ----- Objective -----
% Cost per route: rate * distance * trucks (since trucks make the trip)
var int: total_cost =
  sum(w in Warehouses, p in Ports)( rate_eur_per_km * dist_km[w,p] * trucks[w,p] );

solve minimize total_cost;

% ----- Output -----
output
[
  "Total cost (EUR) = ", show(total_cost), "\n\n",
  "Shipments x[w,p] (containers):\n",
  concat([ wName[w] ++ ": " ++
           concat([ pName[p] ++ "=" ++ show(x[w,p]) ++ (if p<P then ", " else "" endif)
                 | p in Ports ]) ++ "\n"
         | w in Warehouses ]),
  "\nTrucks trucks[w,p]:\n",
  concat([ wName[w] ++ ": " ++
           concat([ pName[p] ++ "=" ++ show(trucks[w,p]) ++ (if p<P then ", " else "" endif)
                 | p in Ports ]) ++ "\n"
         | w in Warehouses ])
];