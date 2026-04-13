% Parameters
int: max_shifts = 40;                 % Total available shifts per month
int: max_energy = 230;                % Total available energy units
int: min_orders = 320;                % Minimum required delivered orders
int: min_scooter_shifts = 5;          % Minimum scooter shifts

int: orders_per_bike_shift = 10;      % Orders delivered per bike shift
int: energy_per_bike_shift = 5;       % Energy used per bike shift
int: tips_per_bike_shift = 50;        % Tips earned per bike shift

int: orders_per_scooter_shift = 7;    % Orders delivered per scooter shift
int: energy_per_scooter_shift = 6;    % Energy used per scooter shift
int: tips_per_scooter_shift = 43;     % Tips earned per scooter shift


% Variables
var 0..max_shifts: bike_shifts;        % Number of bike shifts scheduled
var 0..max_shifts: scooter_shifts;     % Number of scooter shifts scheduled

% Total tips (upper bound assumes all 40 shifts could be either type; loose but safe)
var 0..(tips_per_bike_shift * max_shifts + tips_per_scooter_shift * max_shifts): total_tips;


% Constraints
% Shift availability constraint: total scheduled shifts cannot exceed monthly maximum
constraint
  bike_shifts + scooter_shifts <= max_shifts;

% Energy budget constraint: total energy used by all shifts cannot exceed available energy
constraint
  energy_per_bike_shift * bike_shifts + energy_per_scooter_shift * scooter_shifts <= max_energy;

% Minimum orders constraint: total delivered orders must meet or exceed required minimum
constraint
  orders_per_bike_shift * bike_shifts + orders_per_scooter_shift * scooter_shifts >= min_orders;

% Minimum scooter shifts constraint: must schedule at least the required number of scooter shifts
constraint
  scooter_shifts >= min_scooter_shifts;

% Total tips definition: link total_tips to the chosen number of shifts of each type
constraint
  total_tips = tips_per_bike_shift * bike_shifts + tips_per_scooter_shift * scooter_shifts;


% Objective
solve maximize total_tips;