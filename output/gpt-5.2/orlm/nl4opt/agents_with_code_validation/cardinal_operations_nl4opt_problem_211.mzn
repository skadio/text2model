% Parameters
int: plastic_available = 1000;        % Total units of plastic available
int: solder_available  = 250;         % Total units of solder available

int: plastic_per_mech  = 5;           % Plastic units per mechanical keyboard
int: solder_per_mech   = 2;           % Solder units per mechanical keyboard
int: plastic_per_std   = 2;           % Plastic units per standard keyboard
int: solder_per_std    = 1;           % Solder units per standard keyboard

int: mech_to_std_ratio = 5;           % Target ratio: mechanical = 5 * standard
int: min_standard      = 30;          % Minimum number of standard keyboards

% Upper bounds derived from resource limits (for bounded variables)
int: ub_mechanical = min(plastic_available div plastic_per_mech,
                         solder_available  div solder_per_mech);
int: ub_standard   = min(plastic_available div plastic_per_std,
                         solder_available  div solder_per_std);

% Variables
var 0..ub_mechanical: mechanical;     % Number of mechanical keyboards to produce
var 0..ub_standard:   standard;       % Number of standard keyboards to produce
var 0..(ub_mechanical + ub_standard): total_keyboards; % Total keyboards produced

% Constraints

%--- Production ratio: mechanical keyboards should be five times standard keyboards
constraint
  mechanical = mech_to_std_ratio * standard;

%--- Minimum demand for standard keyboards
constraint
  standard >= min_standard;

%--- Plastic resource capacity constraint
constraint
  plastic_per_mech * mechanical + plastic_per_std * standard <= plastic_available;

%--- Solder resource capacity constraint
constraint
  solder_per_mech * mechanical + solder_per_std * standard <= solder_available;

%--- Define total keyboards produced
constraint
  total_keyboards = mechanical + standard;

% Objective
solve maximize total_keyboards;