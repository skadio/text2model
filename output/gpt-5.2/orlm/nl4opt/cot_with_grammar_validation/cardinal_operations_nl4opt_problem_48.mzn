% Parameters
int: cap_motorcycle = 30;
int: cap_sedan = 70;

int: pol_motorcycle = 4;
int: pol_sedan = 15;

int: earn_motorcycle = 100;
int: earn_sedan = 225;

int: max_pollution = 200;
int: min_transport = 1200;

int: max_motorcycle_percent = 25; % percent

% Variables
var 0..(max_pollution div pol_motorcycle): m; % motorcycles
var 0..(max_pollution div pol_sedan): s;      % sedans

% Constraints
constraint cap_motorcycle * m + cap_sedan * s >= min_transport;
constraint pol_motorcycle * m + pol_sedan * s < max_pollution;

% At most 25% of vehicles are motorcycles: m <= 0.25*(m+s)
% Linearized: 4*m <= (m+s)  ->  3*m <= s
constraint 3 * m <= s;

% Objective
solve maximize earn_motorcycle * m + earn_sedan * s;