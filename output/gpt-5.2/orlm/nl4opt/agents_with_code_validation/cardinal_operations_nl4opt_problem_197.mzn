% Parameters
int: total_antibiotics = 35000;          % Total available units of antibiotics
int: abx_first = 30;                     % Antibiotics required per first-dose vaccine (units)
int: gel_first = 20;                     % Gelatine required per first-dose vaccine (mg)
int: abx_second = 65;                    % Antibiotics required per second-dose vaccine (units)
int: gel_second = 60;                    % Gelatine required per second-dose vaccine (mg)
int: min_second = 40;                    % Minimum number of second-dose vaccines required

% Useful derived bounds (for variable bounding)
int: max_first = total_antibiotics div abx_first;    % Max possible first-dose if only first-dose produced
int: max_second = total_antibiotics div abx_second;  % Max possible second-dose if only second-dose produced

% Variables
var 0..max_first: first_doses;            % Number of first-dose vaccines to manufacture
var 0..max_second: second_doses;          % Number of second-dose vaccines to manufacture
var 0..(gel_first*max_first + gel_second*max_second): total_gelatine; % Total gelatine used (mg)

% Constraints

% Antibiotics availability constraint (cannot exceed total stock)
constraint
  abx_first * first_doses + abx_second * second_doses <= total_antibiotics;

% Precedence/requirement constraint: more first-dose than second-dose vaccines
constraint
  first_doses > second_doses;

% Minimum production requirement for second-dose vaccines
constraint
  second_doses >= min_second;

% Define total gelatine used based on production quantities
constraint
  total_gelatine = gel_first * first_doses + gel_second * second_doses;

% Objective
solve minimize total_gelatine;