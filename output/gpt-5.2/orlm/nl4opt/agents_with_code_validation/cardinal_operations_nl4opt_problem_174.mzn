% Parameters
int: time_electronic  = 3;      % minutes per patient using electronic thermometer
int: time_regular     = 2;      % minutes per patient using regular thermometer
int: total_time       = 15000;  % total minutes the office is open
int: min_regular      = 50;     % minimum number of patients using regular thermometer
int: electronic_ratio = 2;      % at least this many electronic per regular (E >= 2*R)

% Variables
var 0..(total_time div time_electronic): electronic_patients;            % # patients checked electronically
var min_regular..(total_time div time_regular): regular_patients;        % # patients checked regularly
var 0..(total_time div min(time_electronic, time_regular)): total_patients; % total patients checked

% Constraints
% Time capacity constraint: total thermometer time cannot exceed office open time
constraint
  time_electronic * electronic_patients + time_regular * regular_patients
  <= total_time;

% Ratio constraint: at least twice as many electronic as regular (E >= 2*R)
constraint
  electronic_patients >= electronic_ratio * regular_patients;

% Total patients definition: total = electronic + regular
constraint
  total_patients = electronic_patients + regular_patients;

% Objective
solve maximize total_patients;