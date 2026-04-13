% Parameters
int: metal_available = 200;        % Total units of metal available
int: acid_available  = 300;        % Total units of acid available
int: heat_limit      = 50;         % Maximum total heat allowed

int: metal_cheap = 3;              % Metal used per cheap box
int: acid_cheap  = 5;              % Acid used per cheap box
int: foam_cheap  = 8;              % Foam produced per cheap box
int: heat_cheap  = 2;              % Heat produced per cheap box

int: metal_expensive = 5;          % Metal used per expensive box
int: acid_expensive  = 8;          % Acid used per expensive box
int: foam_expensive  = 10;         % Foam produced per expensive box
int: heat_expensive  = 3;          % Heat produced per expensive box


% Variables
var 0..min(metal_available div metal_cheap,
           min(acid_available div acid_cheap,
               heat_limit div heat_cheap)): x_cheap;         % Number of cheap boxes

var 0..min(metal_available div metal_expensive,
           min(acid_available div acid_expensive,
               heat_limit div heat_expensive)): x_expensive; % Number of expensive boxes

% Upper bound uses metal-only bounds (safe for an upper bound); foam is nonnegative
var 0..(foam_cheap * (metal_available div metal_cheap)
        + foam_expensive * (metal_available div metal_expensive)): total_foam; % Total foam produced


% Constraints
%--- Resource constraint: total metal used cannot exceed available metal
constraint
  metal_cheap * x_cheap + metal_expensive * x_expensive <= metal_available;

%--- Resource constraint: total acid used cannot exceed available acid
constraint
  acid_cheap * x_cheap + acid_expensive * x_expensive <= acid_available;

%--- Process/quality constraint: total heat produced cannot exceed heat limit
constraint
  heat_cheap * x_cheap + heat_expensive * x_expensive <= heat_limit;

%--- Accounting constraint: define total foam produced from chosen boxes
constraint
  total_foam = foam_cheap * x_cheap + foam_expensive * x_expensive;


% Objective
solve maximize total_foam;