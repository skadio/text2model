% Parameters (with values embedded)
int: W = 6; % warehouses
int: P = 5; % ports

set of int: Warehouses = 1..W;
set of int: Ports = 1..P;

array[Warehouses] of string: wname = ["Verona","Perugia","Rome","Pescara","Taranto","Lamezia"];
array[Ports] of string: pname = ["Genoa","Venice","Ancona","Naples","Bari"];

array[Warehouses] of int: supply = [10, 12, 20, 24, 18, 40];
array[Ports] of int: demand = [20, 15, 25, 33, 21];

int: rate_eur_per_km = 30;
int: truck_capacity = 2;

array[Warehouses, Ports] of int: dist_km =
[|  290,  115,  355,  715,  810  % Verona
 |  380,  340,  165,  380,  610  % Perugia
 |  505,  530,  285,  220,  450  % Rome
 |  655,  450,  155,  240,  315  % Pescara
 | 1010,  840,  550,  305,   95  % Taranto
 | 1072, 1097,  747,  372,  333  % Lamezia
 |];

% cost per container shipped on lane (w,p)
array[Warehouses, Ports] of int: cost_per_container =
array2d(Warehouses, Ports,
  [ rate_eur_per_km * dist_km[w,p] | w in Warehouses, p in Ports ]
);

% Variables
% x[w,p] = number of containers shipped from warehouse w to port p
array[Warehouses, Ports] of var 0..sum(supply): x;

% Constraints
constraint
  forall(w in Warehouses) (
    sum(p in Ports)(x[w,p]) <= supply[w]
  );

constraint
  forall(p in Ports) (
    sum(w in Warehouses)(x[w,p]) = demand[p]
  );

% Truck capacity: containers must be shippable by integer number of trucks (2 per truck)
constraint
  forall(w in Warehouses, p in Ports) (
    x[w,p] mod truck_capacity = 0
  );

% Objective
var int: total_cost = sum(w in Warehouses, p in Ports)(cost_per_container[w,p] * x[w,p]);

solve minimize total_cost;