% Parameters
int: nStudents = 400;                 % total number of students to transport

int: maxBuses = 10;                   % available buses
int: busSeats = 50;                   % seats per bus
int: busCost = 800;                   % cost per bus (£)

int: maxMinibuses = 8;                % available minibuses
int: minibusSeats = 40;               % seats per minibus
int: minibusCost = 600;               % cost per minibus (£)

int: nDrivers = 9;                    % available drivers (1 per vehicle)

% Variables
var 0..maxBuses: nBusUsed;            % number of buses rented/used
var 0..maxMinibuses: nMinibusUsed;    % number of minibuses rented/used

var 0..(busCost*maxBuses + minibusCost*maxMinibuses): totalCost;  % total rental cost (£)

% Constraints
% Capacity constraint: enough seats for all students
constraint
  busSeats * nBusUsed + minibusSeats * nMinibusUsed >= nStudents;

% Driver availability constraint: one driver per vehicle
constraint
  nBusUsed + nMinibusUsed <= nDrivers;

% Total cost definition constraint
constraint
  totalCost = busCost * nBusUsed + minibusCost * nMinibusUsed;

% Objective
solve minimize totalCost;