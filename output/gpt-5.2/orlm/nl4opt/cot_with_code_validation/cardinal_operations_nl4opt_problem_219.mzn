% Parameters
int: metal_available = 200;
int: acid_available = 300;
int: heat_limit = 50;

int: metal_cheap = 3;
int: acid_cheap = 5;
int: foam_cheap = 8;
int: heat_cheap = 2;

int: metal_exp = 5;
int: acid_exp = 8;
int: foam_exp = 10;
int: heat_exp = 3;

% Variables
var 0..min(metal_available div metal_cheap, min(acid_available div acid_cheap, heat_limit div heat_cheap)): x_cheap;
var 0..min(metal_available div metal_exp, min(acid_available div acid_exp, heat_limit div heat_exp)): x_exp;

var 0..(foam_cheap * (metal_available div metal_cheap) + foam_exp * (metal_available div metal_exp)): total_foam;

% Constraints
constraint metal_cheap * x_cheap + metal_exp * x_exp <= metal_available;
constraint acid_cheap * x_cheap + acid_exp * x_exp <= acid_available;
constraint heat_cheap * x_cheap + heat_exp * x_exp <= heat_limit;

constraint total_foam = foam_cheap * x_cheap + foam_exp * x_exp;

% Objective
solve maximize total_foam;