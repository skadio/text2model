% Parameters
int: metal_available = 800;
int: acid_available = 750;

int: metal_alpha = 3;
int: acid_alpha  = 5;
int: elec_alpha  = 8;

int: metal_beta = 5;
int: acid_beta  = 4;
int: elec_beta  = 10;

% Variables
var 0..min(metal_available div metal_alpha, acid_available div acid_alpha): x_alpha;
var 0..min(metal_available div metal_beta,  acid_available div acid_beta):  x_beta;

var 0..(elec_alpha * (metal_available div metal_alpha) + elec_beta * (metal_available div metal_beta)): total_electricity;

% Constraints
constraint metal_alpha * x_alpha + metal_beta * x_beta <= metal_available;
constraint acid_alpha  * x_alpha + acid_beta  * x_beta <= acid_available;

constraint total_electricity = elec_alpha * x_alpha + elec_beta * x_beta;

% Objective
solve maximize total_electricity;