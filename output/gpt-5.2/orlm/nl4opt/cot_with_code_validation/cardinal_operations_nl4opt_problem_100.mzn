% Parameters
int: wood_available = 120;
int: paint_available = 90;

int: wood_train = 3;
int: paint_train = 3;
int: profit_train = 8;

int: wood_plane = 4;
int: paint_plane = 2;
int: profit_plane = 10;

% Variables
var 0..(wood_available div wood_train): x_train;
var 0..(wood_available div wood_plane): x_plane;

% Constraints
constraint wood_train * x_train + wood_plane * x_plane <= wood_available;
constraint paint_train * x_train + paint_plane * x_plane <= paint_available;

% Objective
solve maximize profit_train * x_train + profit_plane * x_plane;