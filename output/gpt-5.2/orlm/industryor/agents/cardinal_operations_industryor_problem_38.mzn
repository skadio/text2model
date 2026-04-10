% Parameters
int: nMethods = 3;                           % number of transportation methods

set of int: METHODS = 1..nMethods;           % index set for methods
int: MOTORCYCLE = 1;
int: SMALL_TRUCK = 2;
int: LARGE_TRUCK = 3;

array[METHODS] of int: pollution = [40, 70, 100];   % pollution per trip by method
array[METHODS] of int: capacity  = [10, 20, 50];    % product units transported per trip

int: maxMotorcycleTrips = 8;                 % road restriction
int: minTotalProducts = 300;                 % demand requirement
int: maxTotalTrips = 20;                     % total trips upper bound
int: maxTripsPerMethod = maxTotalTrips;      % generic per-method upper bound for bounding vars

% Variables
array[METHODS] of var 0..maxTripsPerMethod: trips;  % number of trips by method
array[METHODS] of var 0..1: useMethod;              % 1 if method is used, else 0 (choose exactly 2)

var 0..(maxTotalTrips * max(pollution)): totalPollution; % objective value (bounded)
var 0..(maxTotalTrips * max(capacity)): totalProducts;   % total transported products (bounded)
var 0..maxTotalTrips: totalTrips;                        % total number of trips (bounded)

% Constraints

% Link totalTrips to the sum of trips across all methods
constraint
  totalTrips = sum(m in METHODS)(trips[m]);

% Link totalProducts to the transported capacity across all methods
constraint
  totalProducts = sum(m in METHODS)(capacity[m] * trips[m]);

% Link totalPollution to the pollution generated across all methods
constraint
  totalPollution = sum(m in METHODS)(pollution[m] * trips[m]);

% Exactly two transportation methods must be chosen
constraint
  sum(m in METHODS)(useMethod[m]) = 2;

% Activate trips only if the corresponding method is chosen (big-M linking)
constraint
  forall(m in METHODS)(
    trips[m] <= maxTripsPerMethod * useMethod[m]
  );

% Road restriction: motorcycle trips cannot exceed the given maximum
constraint
  trips[MOTORCYCLE] <= maxMotorcycleTrips;

% Demand requirement: transport at least the minimum required products
constraint
  totalProducts >= minTotalProducts;

% Total number of trips must be within the allowed maximum
constraint
  totalTrips <= maxTotalTrips;

% Objective
solve minimize totalPollution;