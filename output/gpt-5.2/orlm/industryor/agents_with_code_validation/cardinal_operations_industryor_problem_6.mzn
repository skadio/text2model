% Transportation of empty containers: warehouses -> ports
% Minimize total transport cost (EUR), proportional to distance per container.

% Problem dimensions
int: nWarehouses = 6;
int: nPorts = 5;

set of int: W = 1..nWarehouses;  % Warehouses index
set of int: P = 1..nPorts;       % Ports index

% Cost and capacity parameters
int: euro_per_km = 30;           % EUR per km (per container)
int: truck_capacity = 2;         % containers per truck

% Supply at warehouses (empty containers available)
array[W] of int: supply = [
  10,  % Verona
  12,  % Perugia
  20,  % Rome
  24,  % Pescara
  18,  % Taranto
  40   % Lamezia
];

% Demand at ports (containers required)
array[P] of int: demand = [
  20,  % Genoa
  15,  % Venice
  25,  % Ancona
  33,  % Naples
  21   % Bari
];

% Distances in km from each warehouse to each port
% Rows: warehouses (Verona, Perugia, Rome, Pescara, Taranto, Lamezia)
% Cols: ports (Genoa, Venice, Ancona, Naples, Bari)
array[W, P] of int: dist_km = array2d(W, P, [
   290,  115,  355,  715,  810,   % Verona
   380,  340,  165,  380,  610,   % Perugia
   505,  530,  285,  220,  450,   % Rome
   655,  450,  155,  240,  315,   % Pescara
  1010,  840,  550,  305,   95,   % Taranto
  1072, 1097,  747,  372,  333    % Lamezia
]);

% Derived bounds
int: max_supply = max(supply);

% Decision variables
% x[w,p] = number of containers shipped from warehouse w to port p
array[W, P] of var 0..max_supply: x;

% trucks[w,p] = number of trucks used on lane (w,p)
array[W, P] of var 0..max_supply: trucks;

% Constraints
% Supply constraints
constraint forall(w in W) (
  sum(p in P)(x[w,p]) <= supply[w]
);

% Demand constraints (must meet demand exactly)
constraint forall(p in P) (
  sum(w in W)(x[w,p]) = demand[p]
);

% Truck capacity linking constraints
constraint forall(w in W, p in P) (
  truck_capacity * trucks[w,p] >= x[w,p]
);

% Objective: cost per container = euro_per_km * distance
solve minimize
  sum(w in W, p in P)(
    euro_per_km * dist_km[w,p] * x[w,p]
  );