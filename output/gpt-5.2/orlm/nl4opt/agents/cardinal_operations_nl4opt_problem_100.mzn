% Parameters
int: wood_per_train = 3;      % Wood units required per model train
int: paint_per_train = 3;     % Paint units required per model train
int: wood_per_plane = 4;      % Wood units required per model plane
int: paint_per_plane = 2;     % Paint units required per model plane

int: wood_available = 120;    % Total available wood units
int: paint_available = 90;    % Total available paint units

int: profit_train = 8;        % Profit per model train
int: profit_plane = 10;       % Profit per model plane

% Variables
var 0..(wood_available div wood_per_train): num_trains;  % Number of trains to make
var 0..(wood_available div wood_per_plane): num_planes;  % Number of planes to make

var int: total_profit;        % Total profit to maximize

% Constraints
% Resource usage constraints (wood and paint capacities)
constraint
  wood_per_train * num_trains + wood_per_plane * num_planes <= wood_available;

constraint
  paint_per_train * num_trains + paint_per_plane * num_planes <= paint_available;

% Profit calculation constraint
constraint
  total_profit = profit_train * num_trains + profit_plane * num_planes;

% Objective
solve maximize total_profit;