% Parameters
int: cap_motorcycle = 30;          % people transported per motorcycle per shift
int: cap_sedan      = 70;          % people transported per sedan per shift

int: pol_motorcycle = 4;           % pollution units per motorcycle per shift
int: pol_sedan      = 15;          % pollution units per sedan per shift
int: pol_max        = 199;         % "less than 200" pollution units modeled as <= 199

int: earn_motorcycle = 100;        % earnings per motorcycle per shift ($)
int: earn_sedan      = 225;        % earnings per sedan per shift ($)

int: demand_people   = 1200;       % minimum people to transport per shift


% Variables
var 0..demand_people: n_motorcycles;   % number of motorcycles to use
var 0..demand_people: n_sedans;        % number of sedans to use

var 0..(earn_motorcycle*demand_people + earn_sedan*demand_people): total_earnings;
% total earnings per shift


% Constraints
% Link total earnings to fleet composition
constraint
  total_earnings =
    earn_motorcycle * n_motorcycles +
    earn_sedan      * n_sedans;

% Meet or exceed transportation demand (people per shift)
constraint
  cap_motorcycle * n_motorcycles +
  cap_sedan      * n_sedans
  >= demand_people;

% Pollution must be strictly less than 200 units (modeled as <= 199)
constraint
  pol_motorcycle * n_motorcycles +
  pol_sedan      * n_sedans
  <= pol_max;

% At most 25% of vehicles can be motorcycles:
% n_motorcycles <= 0.25 * (n_motorcycles + n_sedans)
% Multiply through by 4 to keep everything integral.
constraint
  4 * n_motorcycles <= n_motorcycles + n_sedans;


% Objective
solve maximize total_earnings;