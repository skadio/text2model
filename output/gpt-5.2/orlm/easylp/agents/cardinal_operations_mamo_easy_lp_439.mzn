% Parameters
% Staffing costs (units per staff member)
int: cost_doctor = 5;
int: cost_nurse  = 3;

% Service demand / capacity constraints
int: min_service_effort = 50;     % 2*Doctors + Nurses >= 50
int: max_service_mix    = 100;    % Doctors + 3*Nurses <= 100
int: min_doctor_minus_nurse = 10; % Doctors - Nurses >= 10

% Variables
var 0..1000: Doctors;        % number of Doctors (non-negative integer)
var 0..1000: Nurses;         % number of Nurses (non-negative integer)
var 0..1000000: TotalCost;   % total staffing cost (objective)

% Constraints
% Link total cost to staffing decisions
constraint TotalCost = cost_doctor * Doctors + cost_nurse * Nurses;

% Minimum service effort requirement: 2*Doctors + Nurses >= 50
constraint 2 * Doctors + Nurses >= min_service_effort;

% Maximum service mix limit: Doctors + 3*Nurses <= 100
constraint Doctors + 3 * Nurses <= max_service_mix;

% Medical standards requirement: Doctors - Nurses >= 10
constraint Doctors - Nurses >= min_doctor_minus_nurse;

% Objective
solve minimize TotalCost;