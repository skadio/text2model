% Parameters
% Unit costs ($/unit)
int: cost_steel   = 10;
int: cost_wood    = 15;
int: cost_plastic = 20;

% Constraint constants
int: min_twice_steel_plus_wood = 1000;  % 2*steel + wood >= 1000
int: max_steel_plus_plastic    = 2000;  % steel + plastic <= 2000
int: min_wood_minus_plastic    = 500;   % wood - plastic >= 500
int: total_material_required   = 3500;  % steel + wood + plastic = 3500

% Variables
var 0..total_material_required: steel;    % units of steel (integer, nonnegative)
var 0..total_material_required: wood;     % units of wood (integer, nonnegative)
var 0..total_material_required: plastic;  % units of plastic (integer, nonnegative)

% Upper bound: worst case if all 3500 units were each material (loose but safe)
var 0..(cost_steel*total_material_required
      + cost_wood*total_material_required
      + cost_plastic*total_material_required): total_cost; % total cost in dollars


% Constraints

% Material requirement: 2*steel + wood >= minimum
constraint 2 * steel + wood >= min_twice_steel_plus_wood;

% Availability/limit: steel + plastic <= maximum
constraint steel + plastic <= max_steel_plus_plastic;

% Production condition: wood - plastic >= minimum difference
constraint wood - plastic >= min_wood_minus_plastic;

% Total material balance: steel + wood + plastic == required total
constraint steel + wood + plastic = total_material_required;

% Define total cost from unit costs and material quantities
constraint total_cost = cost_steel * steel + cost_wood * wood + cost_plastic * plastic;


% Objective
solve minimize total_cost;