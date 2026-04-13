% Parameters
int: total_morphine_mg = 3000;                 % Total available morphine (mg)

int: morphine_per_painkiller_mg = 10;          % Morphine per painkiller (mg)
int: morphine_per_sleeping_mg = 6;             % Morphine per sleeping pill (mg)

int: digestive_per_painkiller = 3;             % Digestive medicine units per painkiller
int: digestive_per_sleeping = 5;               % Digestive medicine units per sleeping pill

int: min_painkillers = 50;                     % Minimum number of painkiller pills
int: sleeping_share_percent = 70;              % At least 70% of pills are sleeping pills

% Simple upper bounds derived from morphine limit (for bounded variables)
int: max_painkillers = total_morphine_mg div morphine_per_painkiller_mg;
int: max_sleeping = total_morphine_mg div morphine_per_sleeping_mg;

% Variables
var 0..max_painkillers: painkillers;           % Number of painkiller pills to make
var 0..max_sleeping: sleeping;                 % Number of sleeping pills to make

var 0..(digestive_per_painkiller*max_painkillers + digestive_per_sleeping*max_sleeping):
    total_digestive;                           % Total digestive medicine units used

% Constraints

% Morphine availability constraint (resource capacity)
constraint
    morphine_per_painkiller_mg * painkillers
  + morphine_per_sleeping_mg * sleeping
  <= total_morphine_mg;

% Minimum production requirement for painkillers
constraint
  painkillers >= min_painkillers;

% Popularity requirement: at least 70% of all pills are sleeping pills
% sleeping / (painkillers + sleeping) >= 70/100  <=>  100*sleeping >= 70*(painkillers + sleeping)
constraint
  100 * sleeping >= sleeping_share_percent * (painkillers + sleeping);

% Define total digestive medicine usage
constraint
  total_digestive
  = digestive_per_painkiller * painkillers
  + digestive_per_sleeping * sleeping;

% Objective
solve minimize total_digestive;