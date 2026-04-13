% Parameters
int: cost_X = 5000;              % Cost per hire in department X
int: cost_Y = 4000;              % Cost per hire in department Y
int: cost_Z = 6000;              % Cost per hire in department Z

int: total_hires = 50;           % Exact number of employees to hire

int: exp_X = 5;                  % Experience score weight for X
int: exp_Y = 3;                  % Experience score weight for Y
int: exp_Z = 7;                  % Experience score weight for Z
int: min_total_experience = 200; % Minimum required total experience score

int: min_hires_X = 10;           % Minimum hires required in X
int: max_hires_Y = 20;           % Maximum hires allowed in Y

% Variables
var min_hires_X..total_hires: hires_X;  % Number of hires in department X (integer by default)
var 0..max_hires_Y: hires_Y;            % Number of hires in department Y
var 0..total_hires: hires_Z;            % Number of hires in department Z

var 0..(cost_X*total_hires + cost_Y*total_hires + cost_Z*total_hires): total_cost; % Total hiring cost (USD)

% Constraints
% Hiring count balance: hire exactly the required total number of employees
constraint hires_X + hires_Y + hires_Z = total_hires;

% Experience requirement: ensure total experience score meets the minimum threshold
constraint exp_X * hires_X + exp_Y * hires_Y + exp_Z * hires_Z >= min_total_experience;

% Total cost definition: link total_cost to the department hiring decisions
constraint total_cost = cost_X * hires_X + cost_Y * hires_Y + cost_Z * hires_Z;

% Objective
solve minimize total_cost;

output [
  "hires_X=", show(hires_X), "\n",
  "hires_Y=", show(hires_Y), "\n",
  "hires_Z=", show(hires_Z), "\n",
  "total_cost=", show(total_cost), "\n"
];