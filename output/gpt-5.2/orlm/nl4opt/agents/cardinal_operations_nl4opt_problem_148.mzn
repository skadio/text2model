% Parameters
% Production rates (grams per hour)
int: north_injection_rate = 800;
int: north_cream_rate     = 700;
int: west_injection_rate  = 650;
int: west_cream_rate      = 750;

% Plastic usage (units per hour)
int: north_plastic_per_hour = 40;
int: west_plastic_per_hour  = 35;

% Available plastic (units)
int: plastic_available = 60000;

% Minimum required production (grams)
int: min_injections = 800000;
int: min_cream      = 700000;

% Simple upper bound on hours based on plastic limits (for bounded vars)
int: max_hours_north = plastic_available div north_plastic_per_hour;
int: max_hours_west  = plastic_available div west_plastic_per_hour;

% Variables
% Hours to run each factory (nonnegative integers, bounded by plastic-based maxima)
var 0..max_hours_north: hours_north;
var 0..max_hours_west:  hours_west;

% Constraints
% Plastic availability constraint (total plastic used by both factories)
constraint
  north_plastic_per_hour * hours_north +
  west_plastic_per_hour  * hours_west
  <= plastic_available;

% Minimum anti-itch injection production requirement
constraint
  north_injection_rate * hours_north +
  west_injection_rate  * hours_west
  >= min_injections;

% Minimum topical cream production requirement
constraint
  north_cream_rate * hours_north +
  west_injection_rate  * hours_west
  >= min_cream;

% Objective
solve minimize hours_north + hours_west;