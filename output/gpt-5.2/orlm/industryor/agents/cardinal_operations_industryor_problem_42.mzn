% Parameters
% Demand requirements (minimums)
int: min_rawA_pieces = 240;
int: min_rawB_kg     = 80;
int: min_rawC_tons   = 120;

% Payload per truck from each warehouse
int: A_rawA_pieces = 4;
int: A_rawB_kg     = 2;
int: A_rawC_tons   = 6;

int: B_rawA_pieces = 7;
int: B_rawB_kg     = 2;
int: B_rawC_tons   = 2;

% Cost per truck
int: cost_A = 200;
int: cost_B = 160;

% Simple upper bounds (large enough to not cut off optimal solutions)
% (Derived from meeting demands with the smallest per-truck contributions)
int: ub_trucks_A = max([
  (min_rawA_pieces + A_rawA_pieces - 1) div A_rawA_pieces,
  (min_rawB_kg     + A_rawB_kg     - 1) div A_rawB_kg,
  (min_rawC_tons   + A_rawC_tons   - 1) div A_rawC_tons
]);
int: ub_trucks_B = max([
  (min_rawA_pieces + B_rawA_pieces - 1) div B_rawA_pieces,
  (min_rawB_kg     + B_rawB_kg     - 1) div B_rawB_kg,
  (min_rawC_tons   + B_rawC_tons   - 1) div B_rawC_tons
]);
int: ub_trucks_total = ub_trucks_A + ub_trucks_B;

% Variables
var 0..ub_trucks_total: trucks_A; % trucks dispatched daily from warehouse A
var 0..ub_trucks_total: trucks_B; % trucks dispatched daily from warehouse B

% Upper bound on total cost using ub_trucks_total for each route (safe over-approximation)
var 0..(cost_A * ub_trucks_total + cost_B * ub_trucks_total): total_cost;

% Constraints
% Link total cost to the number of trucks dispatched from each warehouse
constraint
  total_cost = cost_A * trucks_A + cost_B * trucks_B;

% Satisfy minimum demand for raw material A (pieces)
constraint
  A_rawA_pieces * trucks_A + B_rawA_pieces * trucks_B >= min_rawA_pieces;

% Satisfy minimum demand for raw material B (kg)
constraint
  A_rawB_kg * trucks_A + B_rawB_kg * trucks_B >= min_rawB_kg;

% Satisfy minimum demand for raw material C (tons)
constraint
  A_rawC_tons * trucks_A + B_rawC_tons * trucks_B >= min_rawC_tons;

% Objective
solve minimize total_cost;