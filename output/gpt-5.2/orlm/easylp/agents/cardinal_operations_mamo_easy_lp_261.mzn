% Parameters
int: costX = 5000;              % Cost per hire in department X
int: costY = 4000;              % Cost per hire in department Y
int: costZ = 6000;              % Cost per hire in department Z

int: total_hires = 50;          % Exact total number of hires required

int: expCoeffX = 5;             % Experience score coefficient for X
int: expCoeffY = 3;             % Experience score coefficient for Y
int: expCoeffZ = 7;             % Experience score coefficient for Z
int: min_experience = 200;      % Minimum total experience score required

int: minX = 10;                 % Minimum hires in department X
int: maxY = 20;                 % Maximum hires in department Y

% Variables
var minX..total_hires: x;       % Number of hires in department X (integer)
var 0..maxY: y;                 % Number of hires in department Y (integer)
var 0..total_hires: z;          % Number of hires in department Z (integer)

var 0..(costX*total_hires + costY*total_hires + costZ*total_hires): total_cost;
                                % Total hiring cost (safe upper bound)

% Constraints
% --- Workforce balance: hire exactly the required total number of employees ---
constraint x + y + z = total_hires;

% --- Diversity/experience requirement: ensure minimum total experience score ---
constraint expCoeffX * x + expCoeffY * y + expCoeffZ * z >= min_experience;

% --- Total cost definition: link decision variables to computed total_cost ---
constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;