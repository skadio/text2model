% Parameters
int: demand = 1800;                      % minimum units to deliver

% Pollution generated per trip
int: poll_truck = 100;
int: poll_van = 50;
int: poll_motorcycle = 10;
int: poll_ev = 0;

int: max_total_pollution = 2000;         % upper limit on total pollution

% Capacity per trip (units delivered per trip)
int: cap_truck = 100;
int: cap_van = 80;
int: cap_motorcycle = 40;
int: cap_ev = 60;

int: min_truck_trips = 10;              % at least this many truck trips

% Safe upper bounds for trips (derived to bound decision variables)
% Max trips needed if using only the smallest capacity mode (motorcycle): ceil(1800/40)=45
int: max_trips = 45;

% Variables
var 0..max_trips: truck_trips;                % number of truck trips
var 0..max_trips: van_trips;                  % number of van trips
var 0..max_trips: motorcycle_trips;           % number of motorcycle trips
var 0..max_trips: ev_trips;                   % number of electric vehicle trips

var 0..max_total_pollution: total_pollution;  % total pollution to minimize

% Total delivered units (upper bound uses truck capacity as a safe max per trip)
var 0..(max_trips * cap_truck): total_delivered;

% Constraints
% Minimum required number of truck trips
constraint truck_trips >= min_truck_trips;

% Mutually exclusive usage: either vans or electric vehicles (or neither), but not both
constraint (van_trips = 0) \/ (ev_trips = 0);

% Total delivered units calculation
constraint total_delivered =
    cap_truck * truck_trips
  + cap_van * van_trips
  + cap_motorcycle * motorcycle_trips
  + cap_ev * ev_trips;

% Demand satisfaction: deliver at least the required units
constraint total_delivered >= demand;

% Total pollution calculation
constraint total_pollution =
    poll_truck * truck_trips
  + poll_van * van_trips
  + poll_motorcycle * motorcycle_trips
  + poll_ev * ev_trips;

% Pollution limit: do not exceed the maximum allowed total pollution
constraint total_pollution <= max_total_pollution;

% Objective
solve minimize total_pollution;