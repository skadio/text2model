% Parameters
int: wood_available = 300;              % Total units of wood available
int: oxygen_available = 300;            % Total units of oxygen available

int: wood_per_catalyst = 10;            % Wood units used per catalyst process
int: oxygen_per_catalyst = 20;          % Oxygen units used per catalyst process
int: co2_per_catalyst = 15;             % CO2 units produced per catalyst process

int: wood_per_nocatalyst = 15;          % Wood units used per non-catalyst process
int: oxygen_per_nocatalyst = 12;        % Oxygen units used per non-catalyst process
int: co2_per_nocatalyst = 18;           % CO2 units produced per non-catalyst process

% Upper bounds derived from resource limits (safe integer bounds)
int: max_catalyst = min(wood_available div wood_per_catalyst,
                        oxygen_available div oxygen_per_catalyst);
int: max_nocatalyst = min(wood_available div wood_per_nocatalyst,
                          oxygen_available div oxygen_per_nocatalyst);

% Variables
var 0..max_catalyst: num_catalyst;      % Number of catalyst processes to run
var 0..max_nocatalyst: num_nocatalyst;  % Number of non-catalyst processes to run

var 0..(co2_per_catalyst * max_catalyst + co2_per_nocatalyst * max_nocatalyst): total_co2;
                                       % Total CO2 produced (objective variable)

% Constraints

% Link total CO2 to the number of processes used
constraint
  total_co2 =
    co2_per_catalyst * num_catalyst +
    co2_per_nocatalyst * num_nocatalyst;

% Wood availability constraint (do not exceed total wood)
constraint
  wood_per_catalyst * num_catalyst +
  wood_per_nocatalyst * num_nocatalyst
  <= wood_available;

% Oxygen availability constraint (do not exceed total oxygen)
constraint
  oxygen_per_catalyst * num_catalyst +
  oxygen_per_nocatalyst * num_nocatalyst
  <= oxygen_available;

% Objective
solve maximize total_co2;