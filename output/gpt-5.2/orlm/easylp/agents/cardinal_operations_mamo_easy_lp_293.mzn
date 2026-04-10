% Parameters
int: max_xy = 30;          % Maximum combined enrollment for courses X and Y
int: max_yz = 20;          % Maximum combined enrollment for courses Y and Z
int: min_xz = 10;          % Minimum combined enrollment for courses X and Z

int: cost_x = 5;           % Cost per student in course X
int: cost_y = 3;           % Cost per student in course Y
int: cost_z = 1;           % Cost per student in course Z


% Variables
var 0..max_xy: students_x;                 % Enrollment in course X (non-negative)
var 0..min(max_xy, max_yz): students_y;    % Enrollment in course Y (non-negative)
var 0..max_yz: students_z;                 % Enrollment in course Z (non-negative)

% Total operational cost (bounded for solver efficiency)
var 0..(cost_x*max_xy + cost_y*min(max_xy,max_yz) + cost_z*max_yz): total_cost;


% Constraints
% Capacity constraints for combined enrollments
constraint students_x + students_y <= max_xy;   % X + Y cannot exceed classroom capacity
constraint students_y + students_z <= max_yz;   % Y + Z cannot exceed faculty availability

% Diversity constraint for course offerings
constraint students_x + students_z >= min_xz;   % X + Z must be at least the minimum threshold

% Define total operational cost from per-student costs
constraint total_cost = cost_x * students_x + cost_y * students_y + cost_z * students_z;


% Objective
solve minimize total_cost;