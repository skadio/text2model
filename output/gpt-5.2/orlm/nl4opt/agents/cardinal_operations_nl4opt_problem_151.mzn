% Parameters
int: magnesium_per_gummy = 3;          % units of magnesium in one gummy
int: zinc_per_gummy = 4;               % units of zinc in one gummy
int: magnesium_per_pill = 2;           % units of magnesium in one pill
int: zinc_per_pill = 5;                % units of zinc in one pill

int: min_pills = 10;                   % at least this many pills must be taken
int: gummy_to_pill_ratio = 3;          % gummies must be at least this multiple of pills
int: max_magnesium = 200;              % maximum total magnesium allowed

% Variables
var 0..(max_magnesium div magnesium_per_gummy): gummies;  % number of gummies eaten
var min_pills..(max_magnesium div magnesium_per_pill): pills; % number of pills taken
var 0..(max_magnesium div min(magnesium_per_gummy, magnesium_per_pill)) * max(zinc_per_gummy, zinc_per_pill): total_zinc; % total zinc intake

% Constraints
% Link total_zinc to chosen numbers of gummies and pills
constraint
  total_zinc = zinc_per_gummy * gummies + zinc_per_pill * pills;

% Magnesium intake must not exceed the allowed maximum
constraint
  magnesium_per_gummy * gummies + magnesium_per_pill * pills <= max_magnesium;

% Preference constraint: eat at least gummy_to_pill_ratio times as many gummies as pills
constraint
  gummies >= gummy_to_pill_ratio * pills;

% Objective
solve maximize total_zinc;