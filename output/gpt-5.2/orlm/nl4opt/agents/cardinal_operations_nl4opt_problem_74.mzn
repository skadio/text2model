% Parameters
int: total_morphine_mg = 3000;              % Total available morphine (mg)
int: morphine_per_painkiller_mg = 10;       % Morphine required per painkiller pill (mg)
int: morphine_per_sleeping_mg = 6;          % Morphine required per sleeping pill (mg)

int: digestive_per_painkiller = 3;          % Digestive medicine units per painkiller pill
int: digestive_per_sleeping = 5;            % Digestive medicine units per sleeping pill

int: min_painkillers = 50;                  % Minimum number of painkiller pills
int: sleeping_ratio_num = 70;               % At least 70% sleeping pills (numerator)
int: sleeping_ratio_den = 100;              % At least 70% sleeping pills (denominator)

% Useful bounds derived from morphine limit
int: max_painkillers = total_morphine_mg div morphine_per_painkiller_mg;  % Upper bound if only painkillers
int: max_sleeping = total_morphine_mg div morphine_per_sleeping_mg;       % Upper bound if only sleeping


% Variables
var 0..max_painkillers: num_painkillers;    % Number of painkiller pills to make
var 0..max_sleeping: num_sleeping;          % Number of sleeping pills to make

var 0..(digestive_per_painkiller*max_painkillers + digestive_per_sleeping*max_sleeping): total_digestive;
                                             % Total digestive medicine units used


% Constraints

% Link total digestive medicine to production quantities
constraint
  total_digestive
    = digestive_per_painkiller * num_painkillers
    + digestive_per_sleeping * num_sleeping;

% Morphine availability constraint (cannot exceed total morphine on hand)
constraint
  morphine_per_painkiller_mg * num_painkillers
  + morphine_per_sleeping_mg * num_sleeping
  <= total_morphine_mg;

% Minimum production requirement for painkillers
constraint
  num_painkillers >= min_painkillers;

% Popularity requirement: at least 70% of all pills are sleeping pills
% Integer-safe form: den * sleeping >= num * (sleeping + painkillers)
constraint
  sleeping_ratio_den * num_sleeping
  >= sleeping_ratio_num * (num_sleeping + num_painkillers);


% Objective
solve minimize total_digestive;

output [
  "num_painkillers = ", show(num_painkillers), "\n",
  "num_sleeping = ", show(num_sleeping), "\n",
  "total_digestive = ", show(total_digestive), "\n"
];