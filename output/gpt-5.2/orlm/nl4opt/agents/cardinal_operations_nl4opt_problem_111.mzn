% Parameters
int: people_available = 30;                 % Total available people
int: people_per_small = 2;                  % People needed per small truck
int: people_per_large = 4;                  % People needed per large truck
int: capacity_small = 30;                   % Snow units carried by a small truck
int: capacity_large = 50;                   % Snow units carried by a large truck

int: min_small_trucks = 10;                 % At least this many small trucks
int: min_large_trucks = 3;                  % At least this many large trucks

% Upper bounds derived from people availability (for bounded variable declarations)
int: max_small_by_people = people_available div people_per_small;
int: max_large_by_people = people_available div people_per_large;

% Variables
var min_small_trucks..max_small_by_people: num_small_trucks;  % Number of small trucks used
var min_large_trucks..max_large_by_people: num_large_trucks;  % Number of large trucks used

% Total snow transported (bounded by max possible given people-based upper bounds)
var 0..(capacity_small * max_small_by_people + capacity_large * max_large_by_people): total_snow;

% Constraints

% --- Workforce (people) capacity constraint ---
constraint
  people_per_small * num_small_trucks + people_per_large * num_large_trucks
  <= people_available;

% --- Minimum truck requirements (also enforced by variable domains, kept for clarity) ---
constraint num_small_trucks >= min_small_trucks;
constraint num_large_trucks >= min_large_trucks;

% --- Fleet composition rule: small trucks must be twice the number of large trucks ---
constraint
  num_small_trucks = 2 * num_large_trucks;

% --- Define total snow transported based on chosen trucks ---
constraint
  total_snow =
    capacity_small * num_small_trucks + capacity_large * num_large_trucks;

% Objective
solve maximize total_snow;