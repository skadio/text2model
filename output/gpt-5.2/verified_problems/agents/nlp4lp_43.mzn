% Parameters

int: K;                                  % Number of types of minerals
set of int: MINERALS = 1..K;             % Index set for minerals

int: SteelQuantity;                       % Amount of steel to produce (tons)

float: ManganesePercent;                  % Required minimum Mn percentage in final steel
float: SiliconMinPercent;                 % Required minimum Si percentage in final steel
float: SiliconMaxPercent;                 % Allowed maximum Si percentage in final steel

array[MINERALS] of float: SiliconContent;   % Si percentage in mineral k
array[MINERALS] of float: ManganeseContent; % Mn percentage in mineral k

float: ManganesePrice;                    % Price per ton of pure Mn addition
array[MINERALS] of float: MaterialCost;   % Purchase cost per ton of mineral k

float: SellingPrice;                      % Selling price per ton of produced steel
float: MeltingPrice;                      % Smelting/melting cost per ton (independent of mineral)


% Variables

array[MINERALS] of var 0.0..float(SteelQuantity): mineral_tons;
% Tons of each mineral k used in the blend

var 0.0..float(SteelQuantity): added_manganese_tons;
% Tons of manganese added directly

var 0.0..float(SteelQuantity): total_input_tons;
% Total tons of inputs (minerals + added manganese); useful for mass-balance constraints

var float: revenue;
% Total revenue from selling the steel

var float: total_material_cost;
% Total purchasing cost of minerals

var float: total_manganese_cost;
% Total cost for added manganese

var float: total_melting_cost;
% Total melting/smelting cost

var float: profit;
% Objective value: revenue - all costs


% Constraints

%--- Mass balance: total inputs must equal the required steel quantity
constraint
  total_input_tons = sum(k in MINERALS)(mineral_tons[k]) + added_manganese_tons;

constraint
  total_input_tons = float(SteelQuantity);

%--- Composition constraints: ensure required Mn and bounded Si in final steel
% Manganese content (at least the required percentage)
constraint
  (sum(k in MINERALS)(mineral_tons[k] * ManganeseContent[k]) + added_manganese_tons)
  >= float(SteelQuantity) * ManganesePercent;

% Silicon content (between min and max percentages)
constraint
  sum(k in MINERALS)(mineral_tons[k] * SiliconContent[k])
  >= float(SteelQuantity) * SiliconMinPercent;

constraint
  sum(k in MINERALS)(mineral_tons[k] * SiliconContent[k])
  <= float(SteelQuantity) * SiliconMaxPercent;

%--- Accounting constraints: define revenue and cost components
constraint
  revenue = float(SteelQuantity) * SellingPrice;

constraint
  total_material_cost = sum(k in MINERALS)(mineral_tons[k] * MaterialCost[k]);

constraint
  total_manganese_cost = added_manganese_tons * ManganesePrice;

% Melting cost applies to all melted inputs (minerals + added Mn), per ton
constraint
  total_melting_cost = total_input_tons * MeltingPrice;

%--- Profit definition
constraint
  profit = revenue - total_material_cost - total_manganese_cost - total_melting_cost;


% Objective
solve maximize profit;