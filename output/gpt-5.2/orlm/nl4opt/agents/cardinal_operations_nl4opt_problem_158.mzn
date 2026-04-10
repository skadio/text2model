% Parameters
int: otter_tricks = 3;              % tricks per otter
int: otter_treats = 3;              % treats per otter
int: dolphin_tricks = 1;            % tricks per dolphin
int: dolphin_treats = 5;            % treats per dolphin

int: min_dolphins = 10;             % minimum number of dolphins
int: max_otter_share_percent = 30;  % max % of performers that can be otters
int: total_treats = 200;            % total treats available


% Variables
var 0..total_treats div otter_treats: num_otters;                 % number of otters used
var min_dolphins..total_treats div dolphin_treats: num_dolphins;  % number of dolphins used

var 0..total_treats: total_performers; % total performers (otters + dolphins)
var 0..(otter_tricks*(total_treats div otter_treats) + dolphin_tricks*(total_treats div dolphin_treats)): total_tricks; % total tricks


% Constraints
% Popularity constraint: ensure at least the minimum number of dolphins are used
constraint
  num_dolphins >= min_dolphins;

% Definition constraints: link aggregate variables to individual performer counts
constraint
  total_performers = num_otters + num_dolphins;

constraint
  total_tricks = otter_tricks * num_otters + dolphin_tricks * num_dolphins;

% Resource constraint: total treats consumed by otters and dolphins cannot exceed available treats
constraint
  otter_treats * num_otters + dolphin_treats * num_dolphins <= total_treats;

% Performer composition constraint: limit otters to at most a given percentage of all performers
% Implemented without division to preserve integer type consistency:
%   num_otters / total_performers <= max_otter_share_percent / 100
constraint
  100 * num_otters <= max_otter_share_percent * total_performers;


% Objective
solve maximize total_tricks;