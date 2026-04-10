% Parameters
int: metal_available = 800;
int: acid_available = 750;

int: alpha_metal = 3;
int: alpha_acid = 5;
int: alpha_elec = 8;

int: beta_metal = 5;
int: beta_acid = 4;
int: beta_elec = 10;

% Variables
var 0..(metal_available div alpha_metal): x_alpha;
var 0..(metal_available div beta_metal): x_beta;

% Constraints
constraint alpha_metal * x_alpha + beta_metal * x_beta <= metal_available;
constraint alpha_acid * x_alpha + beta_acid * x_beta <= acid_available;

% Objective
solve maximize alpha_elec * x_alpha + beta_elec * x_beta;