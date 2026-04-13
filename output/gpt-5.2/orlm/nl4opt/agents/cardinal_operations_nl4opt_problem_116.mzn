% Parameters
int: cap_tube = 50;          % cubic meters per high-pressure tube trailer trip
int: cost_tube = 500;        % cost per high-pressure tube trailer trip ($)
int: cap_tanker = 30;        % cubic meters per liquefied hydrogen tanker trip
int: cost_tanker = 200;      % cost per liquefied hydrogen tanker trip ($)

int: demand = 1000;          % minimum cubic meters to transport
int: budget = 3750;          % maximum total budget ($)

% Upper bounds from budget (tight, integer)
int: max_tube = budget div cost_tube;       % at most this many tube trips
int: max_tanker = budget div cost_tanker;   % at most this many tanker trips

% Variables
var 0..max_tube: trips_tube;       % number of high-pressure tube trailer trips
var 0..max_tanker: trips_tanker;   % number of liquefied hydrogen tanker trips

% Constraints

% Demand satisfaction: total transported volume must meet or exceed the required demand
constraint
  cap_tube * trips_tube + cap_tanker * trips_tanker >= demand;

% Budget limit: total transportation cost must not exceed the available budget
constraint
  cost_tube * trips_tube + cost_tanker * trips_tanker <= budget;

% Method usage relation: tube trailer trips must be strictly less than tanker trips
constraint
  trips_tube < trips_tanker;

% Objective
solve minimize (trips_tube + trips_tanker);