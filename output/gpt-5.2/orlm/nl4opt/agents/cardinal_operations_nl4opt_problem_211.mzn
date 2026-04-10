% Parameters
int: plastic_available = 1000;              % Total units of plastic available
int: solder_available  = 250;               % Total units of solder available

int: plastic_per_mech = 5;                  % Plastic required per mechanical keyboard
int: solder_per_mech  = 2;                  % Solder required per mechanical keyboard

int: plastic_per_std = 2;                   % Plastic required per standard keyboard
int: solder_per_std  = 1;                   % Solder required per standard keyboard

int: min_standard = 30;                     % Minimum number of standard keyboards required
int: mech_to_std_ratio = 5;                 % Desired ratio: mechanical = 5 * standard

% Upper bounds derived from resources (safe, finite bounds for search)
int: max_mechanical = min(plastic_available div plastic_per_mech,
                          solder_available  div solder_per_mech);
int: max_standard   = min(plastic_available div plastic_per_std,
                          solder_available  div solder_per_std);

% Variables
var 0..max_mechanical: mechanical_kb;        % Number of mechanical keyboards to produce
var 0..max_standard:   standard_kb;          % Number of standard keyboards to produce
var 0..(max_mechanical + max_standard): total_kb; % Total keyboards produced

% Constraints

%--- Resource capacity constraints (do not exceed available materials)
constraint
  plastic_per_mech * mechanical_kb + plastic_per_std * standard_kb
  <= plastic_available;

constraint
  solder_per_mech * mechanical_kb + solder_per_std * standard_kb
  <= solder_available;

%--- Production mix constraints (minimum number of standard keyboards)
constraint
  standard_kb >= min_standard;

%--- Target ratio constraint (aim for 5x as many mechanical as standard)
constraint
  mechanical_kb = mech_to_std_ratio * standard_kb;

%--- Total production definition
constraint
  total_kb = mechanical_kb + standard_kb;

% Objective
solve maximize total_kb;