% Parameters
int: metal_available = 200;
int: acid_available  = 300;
int: heat_max        = 50;

int: metal_cheap = 3;
int: acid_cheap  = 5;
int: foam_cheap  = 8;
int: heat_cheap  = 2;

int: metal_expensive = 5;
int: acid_expensive  = 8;
int: foam_expensive  = 10;
int: heat_expensive  = 3;

% Variables
var 0..min(metal_available div metal_cheap, acid_available div acid_cheap): cheap;
var 0..min(metal_available div metal_expensive, acid_available div acid_expensive): expensive;

% Constraints
constraint metal_cheap * cheap + metal_expensive * expensive <= metal_available;
constraint acid_cheap * cheap + acid_expensive * expensive <= acid_available;
constraint heat_cheap * cheap + heat_expensive * expensive <= heat_max;

% Objective
solve maximize foam_cheap * cheap + foam_expensive * expensive;