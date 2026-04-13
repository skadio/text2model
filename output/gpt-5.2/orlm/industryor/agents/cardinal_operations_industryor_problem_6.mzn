% Parameters
% Number of warehouses and ports
int: nWarehouses = 6;
int: nPorts = 5;

set of int: W = 1..nWarehouses;   % Warehouses index set
set of int: P = 1..nPorts;        % Ports index set

% Supply of empty containers available at each warehouse
array[W] of int: supply = [10, 12, 20, 24, 18, 40];

% Demand of containers at each port
array[P] of int: demand = [20, 15, 25, 33, 21];

% Distances in km from each warehouse to each port
array[W, P] of int: dist_km =
[
  % Genoa  Venice Ancona Naples Bari
  290,    115,   355,   715,  810,   % Verona
  380,    340,   165,   380,  610,   % Perugia
  505,    530,   285,   220,  450,   % Rome
  655,    450,   155,   240,  315,   % Pescara
  1010,   840,   550,   305,   95,   % Taranto
  1072,  1097,   747,   372,  333    % Lamezia
];

% Cost parameters
int: euro_per_km = 30;     % 30 euros per km
int: truck_capacity = 2;   % Each truck can carry up to 2 containers

% Useful bounds
int: total_supply = sum(w in W)(supply[w]);
int: total_demand = sum(p in P)(demand[p]);

% Variables
% Number of containers shipped from warehouse w to port p
array[W, P] of var 0..total_supply: ship_cont;

% Number of trucks used on lane (w,p)
% Must be enough to carry shipped containers given capacity 2.
array[W, P] of var 0..total_supply: trucks;


% Constraints

%--- Supply constraints: do not ship more containers than available at each warehouse
constraint
  forall(w in W) (
    sum(p in P)(ship_cont[w, p]) <= supply[w]
  );

%--- Demand constraints: satisfy (at least) the required demand at each port
% (If total_supply == total_demand, this implies exact satisfaction.)
constraint
  forall(p in P) (
    sum(w in W)(ship_cont[w, p]) >= demand[p]
  );

%--- Global feasibility: ensure the instance can meet total demand with total supply
constraint
  total_supply >= total_demand;

%--- Truck capacity constraints: enough trucks to carry shipped containers (2 per truck)
% Enforces: ship_cont[w,p] <= truck_capacity * trucks[w,p]
constraint
  forall(w in W, p in P) (
    ship_cont[w, p] <= truck_capacity * trucks[w, p]
  );

%--- Tightening / integrality strengthening: trucks must be at least ceil(ship/2)
% Avoids fractional relaxation effects by encoding ceil division with integers.
constraint
  forall(w in W, p in P) (
    trucks[w, p] >= (ship_cont[w, p] + truck_capacity - 1) div truck_capacity
  );


% Objective
solve minimize
  sum(w in W, p in P)(
    ship_cont[w, p] * dist_km[w, p] * euro_per_km
  );