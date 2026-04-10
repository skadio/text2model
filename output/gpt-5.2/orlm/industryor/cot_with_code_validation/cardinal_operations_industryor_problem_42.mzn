% Parameters
int: req_A_pieces = 240;
int: req_B_kg     = 80;
int: req_C_tons   = 120;

int: A_A_pieces = 4;
int: A_B_kg     = 2;
int: A_C_tons   = 6;
int: cost_A     = 200;

int: B_A_pieces = 7;
int: B_B_kg     = 2;
int: B_C_tons   = 2;
int: cost_B     = 160;

% Safe upper bounds (derived from meeting each requirement using only one warehouse)
int: ubA = max( max( (req_A_pieces + A_A_pieces - 1) div A_A_pieces,
                     (req_B_kg     + A_B_kg     - 1) div A_B_kg),
                (req_C_tons   + A_C_tons   - 1) div A_C_tons);

int: ubB = max( max( (req_A_pieces + B_A_pieces - 1) div B_A_pieces,
                     (req_B_kg     + B_B_kg     - 1) div B_B_kg),
                (req_C_tons   + B_C_tons   - 1) div B_C_tons);

% Variables
var 0..ubA: xA; % trucks dispatched from warehouse A
var 0..ubB: xB; % trucks dispatched from warehouse B

var 0..(cost_A*ubA + cost_B*ubB): total_cost;

% Constraints
constraint A_A_pieces * xA + B_A_pieces * xB >= req_A_pieces;
constraint A_B_kg     * xA + B_B_kg     * xB >= req_B_kg;
constraint A_C_tons   * xA + B_C_tons   * xB >= req_C_tons;

constraint total_cost = cost_A * xA + cost_B * xB;

% Objective
solve minimize total_cost;