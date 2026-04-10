% Parameters
% Production rates (grams per hour)
int: inj_rate_north = 800;     % anti-itch injections produced per hour at northern factory (g/h)
int: cream_rate_north = 700;   % topical cream produced per hour at northern factory (g/h)
int: inj_rate_west = 650;      % anti-itch injections produced per hour at western factory (g/h)
int: cream_rate_west = 750;    % topical cream produced per hour at western factory (g/h)

% Plastic usage (units per hour)
int: plastic_rate_north = 40;  % plastic units used per hour at northern factory
int: plastic_rate_west  = 35;  % plastic units used per hour at western factory

% Resource availability and minimum demand (units / grams)
int: plastic_available = 60000; % total plastic units available
int: inj_min = 800000;          % minimum anti-itch injections required (g)
int: cream_min = 700000;        % minimum topical cream required (g)

% A safe upper bound on hours (derived from plastic availability)
int: max_hours = plastic_available;  % loose but valid bound since each hour uses >= 1 plastic unit


% Variables
var 0..max_hours: hours_north;    % hours to run northern factory
var 0..max_hours: hours_west;     % hours to run western factory
var 0..2*max_hours: total_hours;  % total time (hours_north + hours_west), for objective use


% Constraints
% --- Total hours definition (linking variable for objective use) ---
constraint total_hours = hours_north + hours_west;

% --- Plastic availability constraint (resource capacity) ---
constraint
  plastic_rate_north * hours_north + plastic_rate_west * hours_west
  <= plastic_available;

% --- Minimum production requirements (demand satisfaction) ---
constraint
  inj_rate_north * hours_north + inj_rate_west * hours_west
  >= inj_min;

constraint
  cream_rate_north * hours_north + cream_rate_west * hours_west
  >= cream_min;


% Objective
solve minimize total_hours;