% Parameters
int: large_capacity = 2000;          % customers carried per large trip
int: small_capacity = 800;           % customers carried per small trip
int: large_pollution = 20;           % pollution units per large trip
int: small_pollution = 15;           % pollution units per small trip

int: max_large_trips = 7;            % maximum number of large trips allowed
int: min_customers = 20000;          % minimum customers to transport
int: min_small_share_pct = 40;       % at least this percent of all trips must be small

% Variables
var 0..max_large_trips: nLarge;      % number of large cruise ship trips

% Safe upper bound for number of small trips (derived from requirements)
var 0..25: nSmall;                   % number of small cruise ship trips

var 0..(max_large_trips + 25): nTrips;      % total number of trips
var 0..(large_capacity*max_large_trips + small_capacity*25): nCustomers; % total customers
var 0..(large_pollution*max_large_trips + small_pollution*25): totalPollution; % total pollution

% Constraints
% --- Define aggregate variables (totals) ---
constraint nTrips = nLarge + nSmall;

constraint nCustomers = large_capacity * nLarge + small_capacity * nSmall;

constraint totalPollution = large_pollution * nLarge + small_pollution * nSmall;

% --- Operational limits ---
constraint nLarge <= max_large_trips;

% --- Demand satisfaction ---
constraint nCustomers >= min_customers;

% --- Minimum share of small trips ---
% At least min_small_share_pct percent of all trips must be small:
% nSmall / nTrips >= min_small_share_pct / 100
% Linearized (avoids division):
constraint 100 * nSmall >= min_small_share_pct * nTrips;

% Objective
solve minimize totalPollution;