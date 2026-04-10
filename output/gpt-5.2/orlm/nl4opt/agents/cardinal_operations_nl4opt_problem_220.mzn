% Parameters
int: min_people = 550;                 % minimum number of locals to transport

int: kayak_capacity = 4;               % people per kayak trip
int: motorboat_capacity = 5;           % people per motorboat trip

int: kayak_time = 5;                   % minutes per kayak trip
int: motorboat_time = 3;               % minutes per motorboat trip

int: max_motorboat_trips = 25;         % upper bound on motorboat trips
int: min_kayak_trip_pct = 75;          % at least 75% of all trips must be kayak trips

% Variables
var 0..ceil(min_people / kayak_capacity): kayak_trips;         % number of kayak trips
var 0..max_motorboat_trips: motorboat_trips;                  % number of motorboat trips

var 0..(kayak_time * ceil(min_people / kayak_capacity)
      + motorboat_time * max_motorboat_trips): total_time;    % total minutes spent on all trips

% Constraints

% Ensure enough total transport capacity to move at least the required number of people
constraint
  kayak_capacity * kayak_trips + motorboat_capacity * motorboat_trips >= min_people;

% Respect the limit on the number of motorboat trips (also enforced by variable domain)
constraint
  motorboat_trips <= max_motorboat_trips;

% Enforce that at least min_kayak_trip_pct percent of all trips are kayak trips
% kayak_trips / (kayak_trips + motorboat_trips) >= min_kayak_trip_pct / 100
% Cross-multiplied to keep integer arithmetic:
constraint
  100 * kayak_trips >= min_kayak_trip_pct * (kayak_trips + motorboat_trips);

% Define total_time as the sum of time spent on kayak and motorboat trips
constraint
  total_time = kayak_time * kayak_trips + motorboat_time * motorboat_trips;

% Objective
solve minimize total_time;