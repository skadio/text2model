% Parameters
int: req_A_pieces = 240;        % Minimum required raw material A (pieces)
int: req_B_kg     = 80;         % Minimum required raw material B (kg)
int: req_C_tons   = 120;        % Minimum required raw material C (tons)

int: capA_A_pieces = 4;         % Truck from warehouse A: A capacity (pieces)
int: capA_B_kg     = 2;         % Truck from warehouse A: B capacity (kg)
int: capA_C_tons   = 6;         % Truck from warehouse A: C capacity (tons)
int: costA_yuan    = 200;       % Truck from warehouse A: cost (yuan per truck)

int: capB_A_pieces = 7;         % Truck from warehouse B: A capacity (pieces)
int: capB_B_kg     = 2;         % Truck from warehouse B: B capacity (kg)
int: capB_C_tons   = 2;         % Truck from warehouse B: C capacity (tons)
int: costB_yuan    = 160;       % Truck from warehouse B: cost (yuan per truck)

% Safe upper bounds (based on meeting each requirement with only one warehouse)
int: maxTrucksA =
  max( (req_A_pieces + capA_A_pieces - 1) div capA_A_pieces,
       max( (req_B_kg     + capA_B_kg     - 1) div capA_B_kg,
            (req_C_tons   + capA_C_tons   - 1) div capA_C_tons ) );

int: maxTrucksB =
  max( (req_A_pieces + capB_A_pieces - 1) div capB_A_pieces,
       max( (req_B_kg     + capB_B_kg     - 1) div capB_B_kg,
            (req_C_tons   + capB_C_tons   - 1) div capB_C_tons ) );


% Variables
var 0..maxTrucksA: trucksA;     % Number of trucks dispatched from warehouse A (per day)
var 0..maxTrucksB: trucksB;     % Number of trucks dispatched from warehouse B (per day)

var 0..(capA_A_pieces*maxTrucksA + capB_A_pieces*maxTrucksB): totalA_pieces; % Total A delivered
var 0..(capA_B_kg*maxTrucksA     + capB_B_kg*maxTrucksB):     totalB_kg;     % Total B delivered
var 0..(capA_C_tons*maxTrucksA   + capB_C_tons*maxTrucksB):   totalC_tons;   % Total C delivered

var 0..(costA_yuan*maxTrucksA + costB_yuan*maxTrucksB): totalCost_yuan;      % Total freight cost


% Constraints
% --- Total delivered material calculations ---
constraint
  totalA_pieces = capA_A_pieces * trucksA + capB_A_pieces * trucksB;

constraint
  totalB_kg     = capA_B_kg     * trucksA + capB_B_kg     * trucksB;

constraint
  totalC_tons   = capA_C_tons   * trucksA + capB_C_tons   * trucksB;

% --- Production requirements (minimum demand satisfaction) ---
constraint
  totalA_pieces >= req_A_pieces;

constraint
  totalB_kg     >= req_B_kg;

constraint
  totalC_tons   >= req_C_tons;

% --- Total freight cost calculation ---
constraint
  totalCost_yuan = costA_yuan * trucksA + costB_yuan * trucksB;


% Objective
solve minimize totalCost_yuan;

output [
  "trucksA = ", show(trucksA), "\n",
  "trucksB = ", show(trucksB), "\n",
  "totalA_pieces = ", show(totalA_pieces), "\n",
  "totalB_kg = ", show(totalB_kg), "\n",
  "totalC_tons = ", show(totalC_tons), "\n",
  "totalCost_yuan = ", show(totalCost_yuan), "\n"
];