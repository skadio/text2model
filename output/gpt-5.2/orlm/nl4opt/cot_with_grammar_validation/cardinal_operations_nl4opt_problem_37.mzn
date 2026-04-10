% Parameters
int: shape_avail = 3000;
int: bake_avail  = 4000;

int: shape_thin = 50;
int: bake_thin  = 90;
int: profit_thin = 5;

int: shape_stubby = 30;
int: bake_stubby  = 150;
int: profit_stubby = 9;

% Variables
var 0..(shape_avail div shape_thin): x_thin;
var 0..(shape_avail div shape_stubby): x_stubby;

% Constraints
constraint shape_thin * x_thin + shape_stubby * x_stubby <= shape_avail;
constraint bake_thin  * x_thin + bake_stubby  * x_stubby <= bake_avail;

% Objective
solve maximize profit_thin * x_thin + profit_stubby * x_stubby;