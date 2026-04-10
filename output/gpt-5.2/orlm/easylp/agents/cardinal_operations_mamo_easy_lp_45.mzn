% Parameters
int: cost_doctor = 10;                 % cost per shift for one doctor
int: cost_nurse  = 20;                 % cost per shift for one nurse
int: min_total_staff = 50;             % minimum required doctors + nurses
int: max_weighted_staff = 120;         % maximum allowed 2*doctors + nurses

% Variables
var 0..max_weighted_staff div 2: doctors;   % number of doctors (integer, nonnegative)
var 0..max_weighted_staff: nurses;          % number of nurses (integer, nonnegative)
var 0..(cost_doctor*(max_weighted_staff div 2) + cost_nurse*max_weighted_staff): total_cost; % total cost per shift

% Constraints
% --- Staffing coverage constraint: ensure enough total staff on duty ---
constraint doctors + nurses >= min_total_staff;

% --- Capacity/budget constraint: limit weighted staffing (2*doctors + nurses) ---
constraint 2 * doctors + nurses <= max_weighted_staff;

% --- Total cost definition: compute staffing cost per shift ---
constraint total_cost = cost_doctor * doctors + cost_nurse * nurses;

% Objective
solve minimize total_cost;