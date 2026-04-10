% Parameters
int: balloon_capacity = 4;          % visitors per hot-air balloon ride
int: gondola_capacity = 6;          % visitors per gondola lift ride
int: balloon_pollution = 10;        % pollution units per hot-air balloon ride
int: gondola_pollution = 15;        % pollution units per gondola lift ride
int: max_balloon_rides = 10;        % maximum number of hot-air balloon rides
int: min_visitors = 70;             % minimum number of visitors to transport

% Upper bound for gondola rides (sufficient for feasibility and bounding)
int: max_gondola_rides = min_visitors div gondola_capacity + 20;

% Variables
var 0..max_balloon_rides: balloon_rides;        % number of hot-air balloon rides
var 0..max_gondola_rides: gondola_rides;        % number of gondola lift rides
var 0..(balloon_pollution*max_balloon_rides + gondola_pollution*max_gondola_rides): total_pollution;

% Constraints

% Total visitors transported must meet or exceed the minimum required
constraint
  balloon_capacity * balloon_rides + gondola_capacity * gondola_rides >= min_visitors;

% Define total pollution as the sum of pollution from each transport method
constraint
  total_pollution =
    balloon_pollution * balloon_rides + gondola_pollution * gondola_rides;

% Objective
solve minimize total_pollution;

output [
  "balloon_rides = ", show(balloon_rides), "\n",
  "gondola_rides = ", show(gondola_rides), "\n",
  "total_pollution = ", show(total_pollution), "\n"
];