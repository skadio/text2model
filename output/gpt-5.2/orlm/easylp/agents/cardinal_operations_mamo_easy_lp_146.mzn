% Parameters
int: max_tanks = 20;              % Maximum deployable tanks
int: max_aircrafts = 15;          % Maximum deployable aircrafts

int: min_strength = 10;           % Minimum required combined strength: 3*T + 2*A >= 10
int: max_other = 30;              % Upper bound for second constraint: 4*T + A <= 30

int: tank_strength_coeff = 3;     % Coefficient of tanks in strength constraint
int: aircraft_strength_coeff = 2; % Coefficient of aircrafts in strength constraint

int: tank_other_coeff = 4;        % Coefficient of tanks in second constraint
int: aircraft_other_coeff = 1;    % Coefficient of aircrafts in second constraint

int: tank_support = 5;            % Support points per tank
int: aircraft_support = 7;        % Support points per aircraft

% Variables
var 0..max_tanks: tanks;          % Number of tanks to deploy (integer, bounded)
var 0..max_aircrafts: aircrafts;  % Number of aircrafts to deploy (integer, bounded)

var 0..(tank_support*max_tanks + aircraft_support*max_aircrafts): total_support;
                                  % Total support points (bounded)

% Constraints
% Combined strength requirement: 3*T + 2*A >= 10
constraint
  tank_strength_coeff * tanks + aircraft_strength_coeff * aircrafts >= min_strength;

% Secondary operational cap: 4*T + 1*A <= 30
constraint
  tank_other_coeff * tanks + aircraft_other_coeff * aircrafts <= max_other;

% Total support points accounting: total_support = 5*T + 7*A
constraint
  total_support = tank_support * tanks + aircraft_support * aircrafts;

% Objective
solve minimize total_support;