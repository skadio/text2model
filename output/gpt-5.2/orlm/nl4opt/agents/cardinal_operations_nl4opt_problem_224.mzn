% Parameters
int: sub_capacity = 100;      % mail pieces per submarine trip
int: boat_capacity = 80;      % mail pieces per boat trip
int: sub_gas = 30;            % liters of gas per submarine trip
int: boat_gas = 25;           % liters of gas per boat trip
int: max_sub_trips = 6;       % maximum allowed submarine trips
int: min_mail = 1000;         % minimum required mail pieces transported
int: boat_min_percent = 50;   % minimum percent of trips that must be by boat

% Variables
var 0..max_sub_trips: sub_trips;  % number of submarine trips (bounded by max)
var 0..1000: boat_trips;          % number of boat trips (upper bound chosen safely)
var 1..1006: total_trips;         % total trips = sub + boat (bounded for safety)
var 0..100000: total_mail;        % total mail transported
var 0..100000: total_gas;         % total gas used

% Constraints
% --- Trip count relationships ---
constraint total_trips = sub_trips + boat_trips;

% --- Mail transported computation and requirement ---
constraint total_mail = sub_capacity * sub_trips + boat_capacity * boat_trips;
constraint total_mail >= min_mail;

% --- Boat minimum percentage of trips ---
% Enforce: 100*boat_trips >= boat_min_percent*(sub_trips + boat_trips)
constraint 100 * boat_trips >= boat_min_percent * total_trips;

% --- Gas usage computation ---
constraint total_gas = sub_gas * sub_trips + boat_gas * boat_trips;

% Objective
solve minimize total_gas;