% Parameters
int: nStudents = 400;              % total number of students to transport
int: nBusesAvailable = 10;         % maximum number of buses available
int: nMinibusesAvailable = 8;      % maximum number of minibuses available
int: seatsPerBus = 50;             % seating capacity per bus
int: seatsPerMinibus = 40;         % seating capacity per minibus
int: nDriversAvailable = 9;        % maximum number of drivers available (1 per vehicle)
int: costPerBus = 800;             % rental cost per bus (£)
int: costPerMinibus = 600;         % rental cost per minibus (£)

% Variables
var 0..nBusesAvailable: nBusesUsed;           % number of buses to rent/use
var 0..nMinibusesAvailable: nMinibusesUsed;   % number of minibuses to rent/use
var 0..(costPerBus*nBusesAvailable + costPerMinibus*nMinibusesAvailable): totalCost; % total rental cost (£)

% Constraints
% Vehicle availability limits are already enforced by variable domains.

% Capacity constraint: enough total seats to transport all students
constraint
  nBusesUsed * seatsPerBus + nMinibusesUsed * seatsPerMinibus >= nStudents;

% Driver constraint: each vehicle needs one driver, limited drivers available
constraint
  nBusesUsed + nMinibusesUsed <= nDriversAvailable;

% Total cost definition: link totalCost to numbers of vehicles used
constraint
  totalCost = nBusesUsed * costPerBus + nMinibusesUsed * costPerMinibus;

% Objective
solve minimize totalCost;