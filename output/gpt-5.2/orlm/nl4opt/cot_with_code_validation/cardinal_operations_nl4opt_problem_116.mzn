% Parameters
int: cap_trailer = 50;        % cubic meters per trip
int: cost_trailer = 500;      % dollars per trip
int: cap_tanker = 30;         % cubic meters per trip
int: cost_tanker = 200;       % dollars per trip
int: demand = 1000;           % minimum cubic meters to transport
int: budget = 3750;           % maximum dollars available

% Variables
var 0..(budget div cost_trailer): x_trailer;  % number of trailer trips
var 0..(budget div cost_tanker): x_tanker;    % number of tanker trips

% Constraints
constraint cap_trailer * x_trailer + cap_tanker * x_tanker >= demand;
constraint cost_trailer * x_trailer + cost_tanker * x_tanker <= budget;
constraint x_trailer < x_tanker;

% Objective
solve minimize (x_trailer + x_tanker);