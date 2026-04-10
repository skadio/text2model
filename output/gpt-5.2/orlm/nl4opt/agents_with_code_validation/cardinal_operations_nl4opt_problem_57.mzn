% Parameters
int: water_per_liquid = 40;          % water units needed per liquid sanitizer
int: alcohol_per_liquid = 50;        % alcohol units needed per liquid sanitizer
int: water_per_foam = 60;            % water units needed per foam sanitizer
int: alcohol_per_foam = 40;          % alcohol units needed per foam sanitizer

int: water_available = 2000;         % total water units available
int: alcohol_available = 2100;       % total alcohol units available

int: max_liquid = 30;                % at most this many liquid sanitizers can be made

int: hands_per_liquid = 30;          % hands cleaned per liquid sanitizer
int: hands_per_foam = 20;            % hands cleaned per foam sanitizer

% Safe upper bounds derived from resource limits and explicit cap on liquids
int: ub_liquid = min(max_liquid, min(water_available div water_per_liquid,
                                    alcohol_available div alcohol_per_liquid));
int: ub_foam = min(water_available div water_per_foam,
                   alcohol_available div alcohol_per_foam);

% Variables
var 0..ub_liquid: n_liquid;          % number of liquid hand sanitizers produced
var 0..ub_foam: n_foam;              % number of foam hand sanitizers produced

var 0..(hands_per_liquid*ub_liquid + hands_per_foam*ub_foam): total_hands_cleaned;
                                      % total hands that can be cleaned

% Constraints

% Resource capacity constraints (do not exceed available water and alcohol)
constraint
  water_per_liquid * n_liquid + water_per_foam * n_foam <= water_available;

constraint
  alcohol_per_liquid * n_liquid + alcohol_per_foam * n_foam <= alcohol_available;

% Production relationship constraint (foam production must exceed liquid production)
constraint
  n_foam > n_liquid;

% Total hands cleaned definition (link total_hands_cleaned to decision variables)
constraint
  total_hands_cleaned
    = hands_per_liquid * n_liquid + hands_per_foam * n_foam;

% Objective
solve maximize total_hands_cleaned;