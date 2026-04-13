% Parameters
int: tricks_per_otter = 3;          % each otter performs 3 tricks
int: treats_per_otter = 3;          % treats needed per otter (for 3 tricks)

int: tricks_per_dolphin = 1;        % each dolphin performs 1 trick
int: treats_per_dolphin = 5;        % treats needed per dolphin (for 1 trick)

int: total_treats = 200;            % total treats available
int: min_dolphins = 10;             % at least 10 dolphins must be used

float: max_otter_fraction = 0.30;   % at most 30% of performers can be otters


% Variables
var 0..(total_treats div treats_per_otter): otters;     % number of otters used
var min_dolphins..(total_treats div treats_per_dolphin): dolphins; % number of dolphins used

% total tricks performed (upper bound based on individual maxima)
var 0..(tricks_per_otter * (total_treats div treats_per_otter)
      + tricks_per_dolphin * (total_treats div treats_per_dolphin)): total_tricks;


% Constraints
% Treat budget: total treats consumed by otters and dolphins cannot exceed available treats
constraint
  treats_per_otter * otters + treats_per_dolphin * dolphins <= total_treats;

% Popularity/availability: enforce minimum number of dolphins
constraint
  dolphins >= min_dolphins;

% Composition limit: at most max_otter_fraction of all performers can be otters
% otters / (otters + dolphins) <= max_otter_fraction  ->  otters <= max_otter_fraction * (otters + dolphins)
constraint
  int2float(otters) <= max_otter_fraction * int2float(otters + dolphins);

% Total tricks definition: link total_tricks to chosen numbers of otters and dolphins
constraint
  total_tricks = tricks_per_otter * otters + tricks_per_dolphin * dolphins;


% Objective
solve maximize total_tricks;