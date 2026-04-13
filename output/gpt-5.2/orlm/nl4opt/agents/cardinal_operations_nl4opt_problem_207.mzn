% Parameters
int: sticks_per_beam  = 30;   % Popsicle sticks needed for one beam bridge
int: glue_per_beam    = 5;    % Glue units needed for one beam bridge
int: sticks_per_truss = 50;   % Popsicle sticks needed for one truss bridge
int: glue_per_truss   = 8;    % Glue units needed for one truss bridge

int: sticks_available = 600;  % Total Popsicle sticks available
int: glue_available   = 100;  % Total glue units available

int: max_truss = 5;           % Maximum number of truss bridges allowed

int: mass_per_beam  = 40;     % Grams supported by one beam bridge
int: mass_per_truss = 60;     % Grams supported by one truss bridge

% Variables
var 0..(sticks_available div sticks_per_beam): beam_bridges;  % Number of beam bridges built
var 0..max_truss: truss_bridges;                              % Number of truss bridges built

% Upper bound based on max possible beams (by sticks) plus max trusses
var 0..(mass_per_beam * (sticks_available div sticks_per_beam) + mass_per_truss * max_truss): total_mass;

% Constraints
% Resource capacity constraints (Popsicle sticks and glue)
constraint sticks_per_beam * beam_bridges + sticks_per_truss * truss_bridges <= sticks_available;
constraint glue_per_beam   * beam_bridges + glue_per_truss   * truss_bridges <= glue_available;

% Build policy constraints (relative counts and explicit truss cap via variable domain)
constraint beam_bridges > truss_bridges;

% Total supported mass definition
constraint total_mass = mass_per_beam * beam_bridges + mass_per_truss * truss_bridges;

% Objective
solve maximize total_mass;