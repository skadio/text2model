% Parameters
int: total_antibiotics = 35000;          % Total available antibiotics (units)

int: abx_first  = 30;                    % Antibiotics per first-dose vaccine (units)
int: gel_first  = 20;                    % Gelatine per first-dose vaccine (mg)

int: abx_second = 65;                    % Antibiotics per second-dose vaccine (units)
int: gel_second = 60;                    % Gelatine per second-dose vaccine (mg)

int: min_second = 40;                    % Minimum required number of second-dose vaccines

% Upper bounds derived from antibiotics limit (keeps decision variables bounded)
int: max_first  = total_antibiotics div abx_first;
int: max_second = total_antibiotics div abx_second;

% Variables
var 0..max_first: n_first;               % Number of first-dose vaccines to produce
var 0..max_second: n_second;             % Number of second-dose vaccines to produce

var 0..(max_first*gel_first + max_second*gel_second): total_gelatine;
                                         % Total gelatine used (mg)

% Constraints
% Antibiotics capacity constraint
constraint
  abx_first * n_first + abx_second * n_second <= total_antibiotics;

% Must produce more first-dose than second-dose vaccines
constraint
  n_first > n_second;

% Minimum production requirement for second-dose vaccines
constraint
  n_second >= min_second;

% Total gelatine definition
constraint
  total_gelatine = gel_first * n_first + gel_second * n_second;

% Objective
solve minimize total_gelatine;