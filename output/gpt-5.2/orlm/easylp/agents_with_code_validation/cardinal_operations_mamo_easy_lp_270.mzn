% Parameters
int: cost_X = 5000;         % Cost per hire in department X
int: cost_Y = 6000;         % Cost per hire in department Y
int: cost_Z = 7000;         % Cost per hire in department Z

int: max_total_hires = 100; % Total hires cannot exceed this

int: cap_X = 50;            % Capacity limit for department X
int: cap_Y = 30;            % Capacity limit for department Y
int: cap_Z = 20;            % Capacity limit for department Z

int: offset_XY = 10;        % X must be at least offset_XY more than 2*Y
int: offset_YZ = 5;         % Y must be at least offset_YZ more than Z


% Variables
var 0..cap_X: hires_X;      % Number of hires in department X
var 0..cap_Y: hires_Y;      % Number of hires in department Y
var 0..cap_Z: hires_Z;      % Number of hires in department Z

% Total cost (upper bound based on max capacities)
var 0..(cap_X*cost_X + cap_Y*cost_Y + cap_Z*cost_Z): total_cost;


% Constraints
% --- Total hires limit (budget headcount constraint) ---
constraint
  hires_X + hires_Y + hires_Z <= max_total_hires;

% --- Strategic staffing ratio constraints between departments ---
% X must be at least (2*Y + offset_XY)
constraint
  hires_X >= 2 * hires_Y + offset_XY;

% Y must be at least (Z + offset_YZ)
constraint
  hires_Y >= hires_Z + offset_YZ;

% --- Total cost definition (linking constraint) ---
constraint
  total_cost = cost_X * hires_X + cost_Y * hires_Y + cost_Z * hires_Z;


% Objective
solve minimize total_cost;