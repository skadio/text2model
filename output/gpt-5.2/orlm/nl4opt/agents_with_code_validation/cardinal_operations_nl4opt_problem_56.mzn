% Parameters
int: high_volume_capacity = 10000;          % US gallons per day per high-volume pipe
int: low_volume_capacity  = 5000;           % US gallons per day per low-volume pipe

int: high_volume_techs = 12;                % technicians needed per high-volume pipe
int: low_volume_techs  = 5;                 % technicians needed per low-volume pipe

int: demand_min = 150000;                   % minimum daily demand (US gallons)
int: techs_available = 160;                 % total technicians available

float: max_high_volume_fraction = 0.35;     % at most this fraction of pipes can be high-volume
int: min_low_volume_pipes = 8;              % minimum number of low-volume pipes

% A safe upper bound on number of pipes (from demand and minimum per-pipe capacity)
% If all pipes were low-volume: 150000 / 5000 = 30
int: max_pipes = 30;


% Variables
var 0..max_pipes: num_high_pipes;           % number of high-volume pipes to use
var 0..max_pipes: num_low_pipes;            % number of low-volume pipes to use

% Total number of pipes (objective helper)
var 0..(2*max_pipes): total_pipes;


% Constraints
% --- Total pipes accounting (objective helper relation) ---
constraint total_pipes = num_high_pipes + num_low_pipes;

% --- Minimum low-volume pipes requirement ---
constraint num_low_pipes >= min_low_volume_pipes;

% --- Demand satisfaction (total daily capacity must meet minimum demand) ---
constraint high_volume_capacity * num_high_pipes
         + low_volume_capacity  * num_low_pipes
         >= demand_min;

% --- Technician availability (do not exceed staff) ---
constraint high_volume_techs * num_high_pipes
         + low_volume_techs  * num_low_pipes
         <= techs_available;

% --- High-volume fraction limit (at most max_high_volume_fraction of all pipes) ---
% Linearization for 0.35: num_high/(num_high+num_low) <= 0.35  <=>  100*H <= 35*(H+L)
constraint 100 * num_high_pipes <= 35 * (num_high_pipes + num_low_pipes);


% Objective
solve minimize total_pipes;