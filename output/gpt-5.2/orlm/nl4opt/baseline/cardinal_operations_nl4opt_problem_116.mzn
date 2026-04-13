% Hydrogen transport planning: minimize total trips

int: cap_tube = 50;      % cubic meters per trip
int: cost_tube = 500;    % dollars per trip

int: cap_tanker = 30;    % cubic meters per trip
int: cost_tanker = 200;  % dollars per trip

int: demand = 1000;      % minimum cubic meters to transport
int: budget = 3750;      % maximum dollars available

% Decision variables: number of trips of each method
var 0..(budget div cost_tube): tube_trips;
var 0..(budget div cost_tanker): tanker_trips;

constraint cap_tube * tube_trips + cap_tanker * tanker_trips >= demand;
constraint cost_tube * tube_trips + cost_tanker * tanker_trips <= budget;
constraint tube_trips < tanker_trips;

solve minimize tube_trips + tanker_trips;

output [
  "tube_trips = ", show(tube_trips), "\n",
  "tanker_trips = ", show(tanker_trips), "\n",
  "total_trips = ", show(tube_trips + tanker_trips), "\n",
  "total_volume = ", show(cap_tube * tube_trips + cap_tanker * tanker_trips), "\n",
  "total_cost = ", show(cost_tube * tube_trips + cost_tanker * tanker_trips), "\n"
];