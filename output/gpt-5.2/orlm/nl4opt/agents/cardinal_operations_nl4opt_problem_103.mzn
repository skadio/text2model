% Parameters
int: balloon_capacity = 4;        % visitors per hot-air balloon ride
int: gondola_capacity = 6;        % visitors per gondola lift ride
int: balloon_pollution = 10;      % pollution units per balloon ride
int: gondola_pollution = 15;      % pollution units per gondola ride
int: max_balloon_rides = 10;      % maximum number of balloon rides allowed
int: min_visitors = 70;           % minimum number of visitors to transport

% Variables
var 0..max_balloon_rides: num_balloon_rides;  % number of hot-air balloon rides

% Safe upper bound: even if balloons max out, gondolas can cover the rest (and more)
var 0..(ceil(min_visitors / gondola_capacity) + min_visitors): num_gondola_rides;
% number of gondola rides

var 0..(balloon_pollution * max_balloon_rides
        + gondola_pollution * (ceil(min_visitors / gondola_capacity) + min_visitors)):
    total_pollution;  % total pollution produced

% Constraints

% Link total pollution to chosen numbers of rides
constraint
  total_pollution =
    balloon_pollution * num_balloon_rides +
    gondola_pollution * num_gondola_rides;

% Ensure at least the minimum number of visitors are transported
constraint
  balloon_capacity * num_balloon_rides +
  gondola_capacity * num_gondola_rides >=
  min_visitors;

% Enforce the maximum number of balloon rides (also implied by variable domain)
constraint
  num_balloon_rides <= max_balloon_rides;

% Objective
solve minimize total_pollution;