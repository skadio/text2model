% Parameters
% Unit costs
int: cost_doctor = 5;                 % Cost per Doctor
int: cost_nurse  = 3;                 % Cost per Nurse

% Operational requirements
int: min_service_demand = 50;         % Minimum required: 2*Doctors + Nurses >= 50
int: max_resource_limit = 100;        % Maximum allowed: Doctors + 3*Nurses <= 100
int: min_doctor_excess  = 10;         % Minimum difference: Doctors >= Nurses + 10


% Variables
% Decision variables (staff counts must be whole numbers)
var 0..1000: Doctors;                 % Number of Doctors
var 0..1000: Nurses;                  % Number of Nurses

% Objective value
var 0..100000: total_cost;            % Total staffing cost


% Constraints
% Service demand requirement: ensure sufficient combined effort
constraint 2 * Doctors + Nurses >= min_service_demand;

% Resource limit requirement: cap combined allocation across services
constraint Doctors + 3 * Nurses <= max_resource_limit;

% Medical standards requirement: maintain minimum doctor surplus over nurses
constraint Doctors - Nurses >= min_doctor_excess;

% Total cost definition: link decision variables to computed staffing cost
constraint total_cost = cost_doctor * Doctors + cost_nurse * Nurses;


% Objective
solve minimize total_cost;