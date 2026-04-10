% Foundry blending / profit maximization
% Fix for "Gecode: Float::linear: Number out of limits":
% - Avoid floats in linear constraints for Gecode by scaling all monetary and percentage
%   data to integers and using int decision variables.
% - Uses integer tons (can be refined by increasing TON_SCALE if needed).

%%%%%%%%%%%%%%
% Parameters %
%%%%%%%%%%%%%%
int: K;
set of int: MINERALS = 1..K;

int: SteelQuantity;                  % tons of steel to produce (integer)

float: ManganesePercent;             % given as percent units (e.g., 0.45 means 0.45%)
float: SiliconMinPercent;            % percent
float: SiliconMaxPercent;            % percent

array[MINERALS] of float: SiliconContent;     % percent in mineral
array[MINERALS] of float: ManganeseContent;   % percent in mineral

float: ManganesePrice;               % price per ton
array[MINERALS] of float: MaterialCost;
float: SellingPrice;                 % selling price per ton
float: MeltingPrice;                 % melting cost per ton processed (applies to mineral tons)

%%%%%%%%%%%%%%%%%%%%
% Integer scaling  %
%%%%%%%%%%%%%%%%%%%%
int: TON_SCALE = 1;                  % 1 = whole tons (increase for finer resolution)

int: PCT_SCALE = 10000;              % fixed-point for percents and prices
                                     % (enough for typical decimals)

% Scaled steel quantity (in "scaled tons")
int: SteelQtyS = SteelQuantity * TON_SCALE;

% Scaled percent inputs (as integer fixed-point percent)
int: MnReqPctS = round(ManganesePercent * PCT_SCALE);
int: SiMinPctS = round(SiliconMinPercent * PCT_SCALE);
int: SiMaxPctS = round(SiliconMaxPercent * PCT_SCALE);

array[MINERALS] of int: SiPctS = [ round(SiliconContent[m]   * PCT_SCALE) | m in MINERALS ];
array[MINERALS] of int: MnPctS = [ round(ManganeseContent[m] * PCT_SCALE) | m in MINERALS ];

% Scaled prices (currency units * PCT_SCALE per ton)
int: MnPriceS      = round(ManganesePrice * PCT_SCALE);
int: SellPriceS    = round(SellingPrice * PCT_SCALE);
int: MeltPriceS    = round(MeltingPrice * PCT_SCALE);
array[MINERALS] of int: MatCostS = [ round(MaterialCost[m] * PCT_SCALE) | m in MINERALS ];

%%%%%%%%%%%%%
% Variables %
%%%%%%%%%%%%%
array[MINERALS] of var 0..SteelQtyS: mineral_tonsS;   % scaled tons of each mineral
var 0..SteelQtyS: added_manganese_tonsS;              % scaled tons of pure Mn added

var 0..SteelQtyS: total_mineral_tonsS;

% Profit in scaled currency units (currency * PCT_SCALE)
var int: profitS;

%%%%%%%%%%%%%%%
% Constraints %
%%%%%%%%%%%%%%%
constraint total_mineral_tonsS = sum(m in MINERALS)(mineral_tonsS[m]);

% Mass balance: minerals + added Mn = steel output
constraint total_mineral_tonsS + added_manganese_tonsS = SteelQtyS;

% Composition constraints:
% Work in "percent * tons" fixed-point:
% - Mn from minerals: sum(tons * MnPctS)/100
% - added manganese contributes 100% Mn => tons * 100%
% To avoid division, multiply everything by 100.

% Minimum Mn requirement in final steel
constraint
  100 * sum(m in MINERALS)(mineral_tonsS[m] * MnPctS[m])
  + (100 * PCT_SCALE) * added_manganese_tonsS
  >= 100 * SteelQtyS * MnReqPctS;

% Silicon bounds in final steel (Si only comes from minerals)
constraint
  100 * sum(m in MINERALS)(mineral_tonsS[m] * SiPctS[m])
  >= 100 * SteelQtyS * SiMinPctS;

constraint
  100 * sum(m in MINERALS)(mineral_tonsS[m] * SiPctS[m])
  <= 100 * SteelQtyS * SiMaxPctS;

% Profit = revenue - costs (all scaled by PCT_SCALE; account for TON_SCALE)
% Each term uses scaled tons; divide by TON_SCALE is avoided by keeping consistent:
% revenueS = (SteelQtyS * SellPriceS) / TON_SCALE
% costsS   = (sum(mineral_tonsS*MatCostS) + added*MnPriceS + total_mineral*MeltPriceS) / TON_SCALE
% To keep integer equality, multiply both sides by TON_SCALE.

constraint
  profitS * TON_SCALE =
      SteelQtyS * SellPriceS
    - ( sum(m in MINERALS)(mineral_tonsS[m] * MatCostS[m])
        + added_manganese_tonsS * MnPriceS
        + total_mineral_tonsS * MeltPriceS );

solve maximize profitS;