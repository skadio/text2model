% Parameters
int: sub_capacity = 100;          % mail pieces per submarine trip
int: boat_capacity = 80;          % mail pieces per boat trip
int: sub_gas = 30;                % liters of gas per submarine trip
int: boat_gas = 25;               % liters of gas per boat trip
int: max_sub_trips = 6;           % maximum number of submarine trips
int: min_mail = 1000;             % minimum number of mail pieces to transport

% If all mail went by boat, we'd need at most ceil(1000/80)=13 trips.
int: max_boat_trips = (min_mail + boat_capacity - 1) div boat_capacity;

% Variables
var 0..max_sub_trips: sub_trips;        % number of submarine trips
var 0..max_boat_trips: boat_trips;      % number of boat trips

% Constraints
% Mail demand: total capacity transported must meet or exceed required mail pieces
constraint
  sub_capacity * sub_trips + boat_capacity * boat_trips >= min_mail;

% Submarine trip limit (already enforced by variable domain, stated explicitly for clarity)
constraint
  sub_trips <= max_sub_trips;

% Minimum 50% of all trips must be by boat:
% boat_trips >= 0.5 * (sub_trips + boat_trips)  <=>  boat_trips >= sub_trips
constraint
  boat_trips >= sub_trips;

% Objective
solve minimize sub_gas * sub_trips + boat_gas * boat_trips;