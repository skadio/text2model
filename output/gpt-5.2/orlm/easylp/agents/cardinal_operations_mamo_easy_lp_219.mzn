% Parameters
int: capacity = 500;              % Maximum total number of items that can be stored

int: minX = 100;                  % Minimum required items of category X
int: minY = 80;                   % Minimum required items of category Y
int: minZ = 120;                  % Minimum required items of category Z

int: costX = 5;                   % Cost per item of category X (dollars)
int: costY = 4;                   % Cost per item of category Y (dollars)
int: costZ = 6;                   % Cost per item of category Z (dollars)

% Variables
var minX..capacity: x;            % Number of items stocked of category X
var minY..capacity: y;            % Number of items stocked of category Y
var minZ..capacity: z;            % Number of items stocked of category Z

var 0..(costX*capacity + costY*capacity + costZ*capacity): totalCost; % Total cost (dollars)

% Constraints
% Capacity constraint: total items stored cannot exceed the available capacity
constraint
  x + y + z <= capacity;

% Total cost definition: link totalCost to decision variables and unit costs
constraint
  totalCost = costX * x + costY * y + costZ * z;

% Objective
solve minimize totalCost;