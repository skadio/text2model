% Parameters
% Transport capacities (cubic meters per trip)
int: cap_tube_trailer = 50;
int: cap_liquid_tanker = 30;

% Transport costs (dollars per trip)
int: cost_tube_trailer = 500;
int: cost_liquid_tanker = 200;

% Requirements / limits
int: min_volume = 1000;      % at least this much hydrogen to transport (m^3)
int: max_budget = 3750;      % available budget ($)

% Simple derived upper bounds (for variable bounding)
int: max_trips_tube_by_budget = max_budget div cost_tube_trailer;
int: max_trips_liquid_by_budget = max_budget div cost_liquid_tanker;


% Variables
var 0..max_trips_tube_by_budget: trips_tube_trailer;      % number of tube trailer trips
var 0..max_trips_liquid_by_budget: trips_liquid_tanker;   % number of liquid tanker trips

% Helper variables for clarity
var 0..(cap_tube_trailer * max_trips_tube_by_budget + cap_liquid_tanker * max_trips_liquid_by_budget): total_volume;
var 0..max_budget: total_cost;
var 0..(max_trips_tube_by_budget + max_trips_liquid_by_budget): total_trips;


% Constraints
% --- Link helper variables to decision variables ---
constraint
  total_volume = cap_tube_trailer * trips_tube_trailer
               + cap_liquid_tanker * trips_liquid_tanker;

constraint
  total_cost = cost_tube_trailer * trips_tube_trailer
             + cost_liquid_tanker * trips_liquid_tanker;

constraint
  total_trips = trips_tube_trailer + trips_liquid_tanker;

% --- Volume requirement: transport at least the minimum required hydrogen ---
constraint
  total_volume >= min_volume;

% --- Budget limit: total spending cannot exceed available budget ---
constraint
  total_cost <= max_budget;

% --- Operational rule: tube trailer trips must be less than liquid tanker trips ---
constraint
  trips_tube_trailer < trips_liquid_tanker;


% Objective
solve minimize total_trips;