% Parameters
int: sticks_per_beam = 30;          % Popsicle sticks needed for one beam bridge
int: glue_per_beam   = 5;           % Glue units needed for one beam bridge
int: sticks_per_truss = 50;         % Popsicle sticks needed for one truss bridge
int: glue_per_truss   = 8;          % Glue units needed for one truss bridge

int: sticks_available = 600;        % Total Popsicle sticks available
int: glue_available   = 100;        % Total glue units available

int: max_truss = 5;                 % Maximum number of truss bridges allowed

int: mass_per_beam  = 40;           % Mass supported by one beam bridge (grams)
int: mass_per_truss = 60;           % Mass supported by one truss bridge (grams)

% Upper bounds derived from resources and explicit limits (to keep vars bounded)
int: ub_beam =
  min(sticks_available div sticks_per_beam, glue_available div glue_per_beam);
int: ub_truss =
  min(max_truss,
      min(sticks_available div sticks_per_truss, glue_available div glue_per_truss));

% Variables
var 0..ub_beam: num_beam;           % Number of beam bridges to build
var 0..ub_truss: num_truss;         % Number of truss bridges to build
var 0..(mass_per_beam*ub_beam + mass_per_truss*ub_truss): total_mass; % Total supported mass (grams)

% Constraints

% Resource constraints: Popsicle sticks budget
constraint
  sticks_per_beam * num_beam + sticks_per_truss * num_truss <= sticks_available;

% Resource constraints: Glue budget
constraint
  glue_per_beam * num_beam + glue_per_truss * num_truss <= glue_available;

% Policy/structure constraints: truss limit and beam dominance
constraint
  num_truss <= max_truss;

constraint
  num_beam > num_truss;

% Definition constraint: total supported mass from chosen bridges
constraint
  total_mass = mass_per_beam * num_beam + mass_per_truss * num_truss;

% Objective
solve maximize total_mass;

output [
  "num_beam=", show(num_beam), "\n",
  "num_truss=", show(num_truss), "\n",
  "total_mass=", show(total_mass), "\n"
];