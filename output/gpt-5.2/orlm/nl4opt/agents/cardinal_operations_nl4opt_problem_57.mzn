% Parameters
int: water_per_liquid = 40;          % Water units required per liquid sanitizer
int: alcohol_per_liquid = 50;        % Alcohol units required per liquid sanitizer
int: water_per_foam = 60;            % Water units required per foam sanitizer
int: alcohol_per_foam = 40;          % Alcohol units required per foam sanitizer

int: water_available = 2000;         % Total water units available
int: alcohol_available = 2100;       % Total alcohol units available

int: hands_per_liquid = 30;          % Hands cleaned per liquid sanitizer
int: hands_per_foam = 20;            % Hands cleaned per foam sanitizer

int: max_liquid = 30;                % Maximum number of liquid sanitizers allowed

% Variables
var 0..max_liquid: liquid;           % Number of liquid sanitizers to make
var 0..min(water_available div water_per_foam,
           alcohol_available div alcohol_per_foam): foam; % Number of foam sanitizers to make

% Constraints
% Resource capacity constraints (do not exceed available water and alcohol)
constraint
  water_per_liquid * liquid + water_per_foam * foam <= water_available;

constraint
  alcohol_per_liquid * liquid + alcohol_per_foam * foam <= alcohol_available;

% Production relationship constraint (foam must exceed liquid)
constraint
  foam > liquid;

% Objective
solve maximize hands_per_liquid * liquid + hands_per_foam * foam;