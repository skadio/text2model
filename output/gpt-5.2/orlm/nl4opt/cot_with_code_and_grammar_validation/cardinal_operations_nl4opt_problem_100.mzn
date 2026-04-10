% Parameters
int: wood_train = 3;
int: paint_train = 3;
int: wood_plane = 4;
int: paint_plane = 2;

int: wood_avail = 120;
int: paint_avail = 90;

int: profit_train = 8;
int: profit_plane = 10;

% Variables
var 0..(wood_avail div wood_train): trains;
var 0..(wood_avail div wood_plane): planes;
var 0..(profit_train*(wood_avail div wood_train) + profit_plane*(wood_avail div wood_plane)): total_profit;

% Constraints
constraint wood_train * trains + wood_plane * planes <= wood_avail;
constraint paint_train * trains + paint_plane * planes <= paint_avail;

constraint total_profit = profit_train * trains + profit_plane * planes;

% Objective
solve maximize total_profit;