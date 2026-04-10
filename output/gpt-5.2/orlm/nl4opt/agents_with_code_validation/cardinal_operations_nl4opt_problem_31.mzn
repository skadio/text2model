% Parameters
int: wood_available = 300;              % Total units of wood available
int: oxygen_available = 300;            % Total units of oxygen available

int: wood_per_catalyst = 10;            % Wood used per catalyst process
int: oxygen_per_catalyst = 20;          % Oxygen used per catalyst process
int: co2_per_catalyst = 15;             % CO2 produced per catalyst process

int: wood_per_nocatalyst = 15;          % Wood used per non-catalyst process
int: oxygen_per_nocatalyst = 12;        % Oxygen used per non-catalyst process
int: co2_per_nocatalyst = 18;           % CO2 produced per non-catalyst process

% Variables
var 0..(wood_available div wood_per_catalyst): n_catalyst;        % Number of catalyst processes
var 0..(wood_available div wood_per_nocatalyst): n_nocatalyst;    % Number of non-catalyst processes

% Total CO2 produced (upper bound based on max possible uses by wood alone)
var 0..(co2_per_catalyst * (wood_available div wood_per_catalyst)
      + co2_per_nocatalyst * (wood_available div wood_per_nocatalyst)): total_co2;

% Constraints
% Link total CO2 production to the chosen number of processes
constraint total_co2 =
  co2_per_catalyst * n_catalyst + co2_per_nocatalyst * n_nocatalyst;

% Resource constraint: wood usage cannot exceed availability
constraint wood_per_catalyst * n_catalyst
        + wood_per_nocatalyst * n_nocatalyst
        <= wood_available;

% Resource constraint: oxygen usage cannot exceed availability
constraint oxygen_per_catalyst * n_catalyst
        + oxygen_per_nocatalyst * n_nocatalyst
        <= oxygen_available;

% Objective
solve maximize total_co2;