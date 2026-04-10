include "globals.mzn";

% Data (embedded from problem statement)
int: cap_trailer = 50;     % cubic meters per trip
int: cost_trailer = 500;   % dollars per trip

int: cap_tanker = 30;      % cubic meters per trip
int: cost_tanker = 200;    % dollars per trip

int: demand = 1000;        % at least this much hydrogen
int: budget = 3750;        % total cost cannot exceed this

% Decision variables: number of trips by each method
% Upper bounds derived from budget (cannot spend more than budget on each type alone)
var 0..(budget div cost_trailer): trailer_trips;
var 0..(budget div cost_tanker):  tanker_trips;

% Constraints
constraint cap_trailer * trailer_trips + cap_tanker * tanker_trips >= demand;
constraint cost_trailer * trailer_trips + cost_tanker * tanker_trips <= budget;
constraint trailer_trips < tanker_trips;

% Objective: minimize total number of trips
var 0..(budget div cost_trailer + budget div cost_tanker): total_trips =
  trailer_trips + tanker_trips;

solve minimize total_trips;

output [
  "Trailer trips = ", show(trailer_trips), "\n",
  "Tanker trips  = ", show(tanker_trips), "\n",
  "Total trips   = ", show(total_trips), "\n",
  "Total volume  = ", show(cap_trailer * trailer_trips + cap_tanker * tanker_trips), "\n",
  "Total cost    = ", show(cost_trailer * trailer_trips + cost_tanker * tanker_trips), "\n"
];