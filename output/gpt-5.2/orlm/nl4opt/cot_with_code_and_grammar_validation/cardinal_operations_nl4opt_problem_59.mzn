% Parameters
int: metal_available = 800;
int: acid_available = 750;

int: metal_alpha = 3;
int: acid_alpha = 5;
int: elec_alpha = 8;

int: metal_beta = 5;
int: acid_beta = 4;
int: elec_beta = 10;

% Variables
var 0..(metal_available div metal_alpha): x_alpha;
var 0..(metal_available div metal_beta): x_beta;

% Constraints
constraint metal_alpha * x_alpha + metal_beta * x_beta <= metal_available;
constraint acid_alpha * x_alpha + acid_beta * x_beta <= acid_available;

% Objective
solve maximize elec_alpha * x_alpha + elec_beta * x_beta;