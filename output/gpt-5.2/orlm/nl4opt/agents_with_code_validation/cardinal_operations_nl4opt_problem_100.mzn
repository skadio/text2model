% Parameters
int: wood_per_train = 3;          % units of wood needed per model train
int: paint_per_train = 3;         % units of paint needed per model train
int: wood_per_plane = 4;          % units of wood needed per model plane
int: paint_per_plane = 2;         % units of paint needed per model plane

int: wood_available = 120;        % total available wood
int: paint_available = 90;        % total available paint

int: profit_per_train = 8;        % profit per model train
int: profit_per_plane = 10;       % profit per model plane

% Variables
var 0..(wood_available div wood_per_train): num_trains;  % number of model trains to make
var 0..(wood_available div wood_per_plane): num_planes;  % number of model planes to make

% Upper bound is safe (cannot exceed making only trains + only planes as a loose bound)
var 0..(profit_per_train * (wood_available div wood_per_train)
      + profit_per_plane * (wood_available div wood_per_plane)): total_profit; % total profit

% Constraints
% Resource capacity constraints (do not exceed available materials)
constraint
  wood_per_train * num_trains + wood_per_plane * num_planes <= wood_available;

constraint
  paint_per_train * num_trains + paint_per_plane * num_planes <= paint_available;

% Profit accounting constraint (define total profit from chosen quantities)
constraint
  total_profit = profit_per_train * num_trains + profit_per_plane * num_planes;

% Objective
solve maximize total_profit;