% Parameters
int: demand = 1000;                         % minimum total units of produce to transport
int: pollution_limit = 1000;                % maximum total pollution allowed
int: min_horse_trips = 8;                   % minimum number of horse trips

int: pollution_horse = 80;                  % pollution per horse trip
int: pollution_bicycle = 0;                 % pollution per bicycle trip
int: pollution_handcart = 0;                % pollution per handcart trip

int: cap_horse = 55;                        % units carried per horse trip
int: cap_bicycle = 30;                      % units carried per bicycle trip
int: cap_handcart = 40;                     % units carried per handcart trip

% Safe upper bound on trips: all produce by smallest capacity (bicycle) => ceil(1000/30)=34
int: max_trips = 34;

% Variables
var 0..max_trips: trips_horse;              % number of horse trips
var 0..max_trips: trips_bicycle;            % number of bicycle trips
var 0..max_trips: trips_handcart;           % number of handcart trips

var bool: use_bicycle;                      % true if bicycle is the chosen demanding method
var bool: use_handcart;                     % true if handcart is the chosen demanding method

var 0..pollution_limit: total_pollution;    % total pollution generated
var 0..(max_trips * cap_horse + max_trips * cap_bicycle + max_trips * cap_handcart): total_transport; % total transported units

% Constraints

% --- Choose exactly one physically demanding method (bicycle or handcart) ---
constraint
  bool2int(use_bicycle) + bool2int(use_handcart) = 1;

% --- Link chosen method to allowed trips (disable trips for the unchosen option) ---
constraint
  trips_bicycle <= max_trips * bool2int(use_bicycle);
constraint
  trips_handcart <= max_trips * bool2int(use_handcart);

% --- Minimum horse usage requirement ---
constraint
  trips_horse >= min_horse_trips;

% --- Define total pollution from trips ---
constraint
  total_pollution =
    pollution_horse * trips_horse +
    pollution_bicycle * trips_bicycle +
    pollution_handcart * trips_handcart;

% --- Pollution limit ---
constraint
  total_pollution <= pollution_limit;

% --- Define total transported produce from trips ---
constraint
  total_transport =
    cap_horse * trips_horse +
    cap_bicycle * trips_bicycle +
    cap_handcart * trips_handcart;

% --- Demand satisfaction ---
constraint
  total_transport >= demand;

% Objective
solve minimize total_pollution;

output [
  "trips_horse=", show(trips_horse), "\n",
  "trips_bicycle=", show(trips_bicycle), "\n",
  "trips_handcart=", show(trips_handcart), "\n",
  "use_bicycle=", show(use_bicycle), "\n",
  "use_handcart=", show(use_handcart), "\n",
  "total_transport=", show(total_transport), "\n",
  "total_pollution=", show(total_pollution), "\n"
];