include <boardgame_insert_toolkit_lib.2.scad>;

// determines whether lids are output.
g_b_print_lid = true;

// determines whether boxes are output.
g_b_print_box = true;

// Focus on one box
g_isolated_print_box = "";

// Used to visualize how all of the boxes fit together.
g_b_visualization = false;

// this is the outer wall thickness.
//Default = 1.5mm
g_wall_thickness = 1;

// The tolerance value is extra space put between planes of the lid and box that fit together.
// Increase the tolerance to loosen the fit and decrease it to tighten it.
//
// Note that the tolerance is applied exclusively to the lid.
// So if the lid is too tight or too loose, change this value ( up for looser fit, down for tighter fit ) and
// you only need to reprint the lid.
//
// The exception is the stackable box, where the bottom of the box is the lid of the box below,
// in which case the tolerance also affects that box bottom.
// Default = 0.15   .1 works better for .4mm nozzle  .15 works better for .6mm nozzle
g_tolerance = 0.15;

// This adjusts the position of the lid detents downward.
// The larger the value, the bigger the gap between the lid and the box.
g_tolerance_detents_pos = 0.1;

data =
[
    [   "Development Cards",
        [
            [ ENABLED_B, f ],
            [ BOX_SIZE_XYZ,                                     [190, 26, 70] ],
            [ BOX_STACKABLE_B, f ],
            [ BOX_LID,
                [
                    [ LID_SOLID_B, f],
                    [ LID_FIT_UNDER_B, t],
					[ LID_PATTERN_RADIUS,         5],        
					[ LID_PATTERN_N1,               8 ],
					[ LID_PATTERN_N2,               8 ],
					[ LID_PATTERN_ANGLE,            22.5 ],
					[ LID_PATTERN_ROW_OFFSET,       10 ],
					[ LID_PATTERN_COL_OFFSET,       130 ],
					[ LID_PATTERN_THICKNESS,        .6	 ],
                ]
            ],
            [ BOX_COMPONENT,								// Uses built-in dividers
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 45.75, 7, 69 ] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [4,3] ],
					[ POSITION_XY, [ CENTER, CENTER ] ],
                    [ CMP_CUTOUT_SIDES_4B, [ t, t, f, f] ],
                    [ CMP_CUTOUT_TYPE, BOTH	],
					[ CMP_CUTOUT_HEIGHT_PCT, 20],
                    [ CMP_CUTOUT_WIDTH_PCT, 60],
                ]
            ],
        ]
    ],
    [   "Player Tokens - 1p",
        [
            [ ENABLED_B, f ],
            [ BOX_SIZE_XYZ,                                     [59, 53, 16.5] ],
            [ BOX_STACKABLE_B, f ],
            [ BOX_LID,
                [
                    [ LID_SOLID_B, f],
                    [ LID_FIT_UNDER_B, t],
					[ LID_PATTERN_RADIUS,         5],        
					[ LID_PATTERN_N1,               8 ],
					[ LID_PATTERN_N2,               8 ],
					[ LID_PATTERN_ANGLE,            22.5 ],
					[ LID_PATTERN_ROW_OFFSET,       10 ],
					[ LID_PATTERN_COL_OFFSET,       130 ],
					[ LID_PATTERN_THICKNESS,        .6	 ],
                ]
            ],
            [ BOX_COMPONENT,
                [
                    [ CMP_COMPARTMENT_SIZE_XYZ,  	[ 55, 49, 15.5] ],
                    [ CMP_NUM_COMPARTMENTS_XY,      [1, 1] ],
					[ POSITION_XY, [ CENTER, CENTER ] ],
					[ CMP_SHAPE, SQUARE ],
                ]
            ],
        ]
    ],

    [   "Resource Tokens - 2 boxes",
        [
            [ ENABLED_B, f ],
            [ BOX_SIZE_XYZ,                                     [156, 94, 17] ],
            [ BOX_STACKABLE_B, f ],
            [ BOX_LID,
                [
                    [ LID_SOLID_B, f],
                    [ LID_FIT_UNDER_B, t],
					[ LID_PATTERN_RADIUS,         5],        
					[ LID_PATTERN_N1,               8 ],
					[ LID_PATTERN_N2,               8 ],
					[ LID_PATTERN_ANGLE,            22.5 ],
					[ LID_PATTERN_ROW_OFFSET,       10 ],
					[ LID_PATTERN_COL_OFFSET,       130 ],
					[ LID_PATTERN_THICKNESS,        .6	 ],
                ]
            ],
            [ BOX_COMPONENT,									//Stone and Wood, small
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 38, 54.5, 16] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [2,1] ],
					[ POSITION_XY,               [ 1, 1] ],
					[ CMP_SHAPE, FILLET ],
					[ CMP_FILLET_RADIUS, 5 ],
					[ CMP_SHAPE_ROTATED_B, t],
                ]
            ],
            [ BOX_COMPONENT,									//Stone and Wood, large
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 38, 34.5, 16] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [ 2, 1] ],
					[ POSITION_XY,               [ 1, 56.5] ],
					[ CMP_SHAPE, FILLET ],
					[ CMP_FILLET_RADIUS, 5 ],
					[ CMP_SHAPE_ROTATED_B, t],
                ]
            ],
            [ BOX_COMPONENT,									//Servants, small
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 74, 54.5, 16] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [ 1, 1] ],
					[ POSITION_XY,               [ 79, 1] ],
					[ CMP_SHAPE, FILLET ],
					[ CMP_FILLET_RADIUS, 5 ],
					[ CMP_SHAPE_ROTATED_B, t],
                ]
            ],
            [ BOX_COMPONENT,									//Servants, large
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 74, 34.5, 16] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [ 1, 1] ],
					[ POSITION_XY,               [ 79, 56.5 ]],
					[ CMP_SHAPE, FILLET ],
					[ CMP_FILLET_RADIUS, 5 ],
					[ CMP_SHAPE_ROTATED_B, t],
                ]
            ],
        ]
    ],
    [   "Coins - 2 trays",
        [
            [ ENABLED_B, t ],
            [ BOX_SIZE_XYZ,                                     [93, 93, 12] ],
            [ BOX_STACKABLE_B, f ],
            [ BOX_LID,
                [
                    [ LID_SOLID_B, f],
                    [ LID_FIT_UNDER_B, t],
					[ LID_PATTERN_RADIUS,         5],        
					[ LID_PATTERN_N1,               8 ],
					[ LID_PATTERN_N2,               8 ],
					[ LID_PATTERN_ANGLE,            22.5 ],
					[ LID_PATTERN_ROW_OFFSET,       10 ],
					[ LID_PATTERN_COL_OFFSET,       130 ],
					[ LID_PATTERN_THICKNESS,        .6	 ],
                ]
            ],
            [ BOX_COMPONENT,									//1-Coins and 5-Coins
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 90, 90, 11] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [ 1, 1] ],
					[ POSITION_XY,               [ CENTER, CENTER ]],
					[ CMP_SHAPE, FILLET ],
					[ CMP_FILLET_RADIUS, 5 ],
					[ CMP_SHAPE_ROTATED_B, f],
                ]
            ],
        ]
    ],

    [   "v3 flat layer - Main Bits: Leader Cards, Excommunication Tiles, 2p-3p Tokens, Dice, Bonus Tiles, and 5p-Overlay",
        [
            [ ENABLED_B, f ],
            [ BOX_SIZE_XYZ,                                     [190, 139, 26] ],
            [ BOX_STACKABLE_B, f ],
            [ BOX_LID,
                [
                    [ LID_SOLID_B, f],
                    [ LID_FIT_UNDER_B, t],
					[ LID_PATTERN_RADIUS,         5],        
					[ LID_PATTERN_N1,               8 ],
					[ LID_PATTERN_N2,               8 ],
					[ LID_PATTERN_ANGLE,            22.5 ],
					[ LID_PATTERN_ROW_OFFSET,       10 ],
					[ LID_PATTERN_COL_OFFSET,       130 ],
					[ LID_PATTERN_THICKNESS,        .6	 ],
                ]
            ],
            [ BOX_COMPONENT,									//Leader Cards
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 93, 61, 19] ],
                    [ CMP_NUM_COMPARTMENTS_XY,               [1,2] ],
					[ POSITION_XY,               [ 1, 1 ]],
					[ CMP_SHAPE, SQUARE ],
                    [ CMP_CUTOUT_SIDES_4B, [ f, f, t, f] ],
                    [ CMP_CUTOUT_TYPE, EXTERIOR ],
					[ CMP_CUTOUT_HEIGHT_PCT, 100 ],
                    [ CMP_CUTOUT_WIDTH_PCT, 20],
                ]
            ],
            [ BOX_COMPONENT,									//Excommunication Tiles
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 30, 54, 19] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [3,1] ],
					[ POSITION_XY,               [ 95, 1 ]],
					[ CMP_SHAPE, SQUARE ],
                    [ CMP_CUTOUT_SIDES_4B, [ t, f, f, f] ],
                    [ CMP_CUTOUT_TYPE, EXTERIOR ],
					[ CMP_CUTOUT_HEIGHT_PCT, 100 ],
                    [ CMP_CUTOUT_WIDTH_PCT, 50],
                ]
            ],
            [ BOX_COMPONENT,									//2-3p Tokens
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 92, 45, 8] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [1,1] ],
					[ POSITION_XY,               [ 95, 56 ]],
					[ CMP_SHAPE, SQUARE ],
                ]
            ],
            [ BOX_COMPONENT,									//Dice
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 92, 22, 22] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [1,1] ],
					[ POSITION_XY,               [ 95, 102 ]],
					[ CMP_SHAPE, FILLET ],
					//[ CMP_FILLET_RADIUS, 5 ],
					[ CMP_SHAPE_ROTATED_B, f],
                ]
            ],
            [ BOX_COMPONENT,									//Bonus tiles
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 158, 11, 19.5] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [1,1] ],
					[ POSITION_XY,               [ CENTER, 125 ]],
					[ CMP_SHAPE, SQUARE ],
                    [ CMP_CUTOUT_SIDES_4B, [ f, t, f, f] ],
                    [ CMP_CUTOUT_TYPE, EXTERIOR ],
					[ CMP_CUTOUT_HEIGHT_PCT, 100 ],
                    [ CMP_CUTOUT_WIDTH_PCT, 15],
                ]
            ],
            [ BOX_COMPONENT,									//5p council tile flat on bottom (thick in Y axis)
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 34, 109, 22] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [1,1] ],
					[ POSITION_XY,               [ 16, 1 ]],
					[ CMP_SHAPE, SQUARE ],
                ]
            ],
            [ BOX_COMPONENT,									//5p council tile flat on bottom (thin in X axis)
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 154, 28, 22] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [1,1] ],
					[ POSITION_XY,               [ 16, 24 ]],
					[ CMP_SHAPE, SQUARE ],
                ]
            ],
        ]
    ],

	[   "Special Tokens, Visconti Tokens",
        [
            [ ENABLED_B, f ],
            [ BOX_SIZE_XYZ,                                     [190, 26, 17] ],
            [ BOX_STACKABLE_B, f ],
            [ BOX_LID,
                [
                    [ LID_SOLID_B, f],
                    [ LID_FIT_UNDER_B, t],
					[ LID_PATTERN_RADIUS,         5],        
					[ LID_PATTERN_N1,               8 ],
					[ LID_PATTERN_N2,               8 ],
					[ LID_PATTERN_ANGLE,            22.5 ],
					[ LID_PATTERN_ROW_OFFSET,       10 ],
					[ LID_PATTERN_COL_OFFSET,       130 ],
					[ LID_PATTERN_THICKNESS,        .6	 ],
                ]
            ],
            [ BOX_COMPONENT,									//6 stacks Special tokens
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 21, 21, 12 ] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [ 6, 1] ],
					[ POSITION_XY,               [ 11, CENTER ]],
					[ CMP_SHAPE, ROUND ],
					[ CMP_SHAPE_VERTICAL_B, t ],
                    [ CMP_CUTOUT_SIDES_4B, [ t, t, f, f] ],
                    [ CMP_CUTOUT_TYPE, EXTERIOR ],
					[ CMP_CUTOUT_HEIGHT_PCT, 100 ],
                    [ CMP_CUTOUT_WIDTH_PCT, 66],
					[ CMP_CUTOUT_DEPTH_PCT, 25 ],
                ]
            ],
            [ BOX_COMPONENT,									//1 stack Visconti tokens
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 21, 21, 12 ] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [ 1, 1] ],
					[ POSITION_XY,               [ 153, CENTER ]],
					[ CMP_SHAPE, ROUND ],
					[ CMP_SHAPE_VERTICAL_B, t ],
                    [ CMP_CUTOUT_SIDES_4B, [ t, t, f, f] ],
                    [ CMP_CUTOUT_TYPE, EXTERIOR ],
					[ CMP_CUTOUT_HEIGHT_PCT, 100 ],
                    [ CMP_CUTOUT_WIDTH_PCT, 66],
					[ CMP_CUTOUT_DEPTH_PCT, 25 ],
                ]
            ],
        ]
    ],

	    [   "Expansion V3: Auction Tiles, Family Tiles, Brown Pawn, Faith (no tokens)",
        [
            [ ENABLED_B, f ],
            [ BOX_SIZE_XYZ,                                     [190, 117.5, 17] ],
            [ BOX_STACKABLE_B, f ],
            [ BOX_LID,
                [
                    [ LID_SOLID_B, f],
                    [ LID_FIT_UNDER_B, t],
					[ LID_PATTERN_RADIUS,         5],        
					[ LID_PATTERN_N1,               8 ],
					[ LID_PATTERN_N2,               8 ],
					[ LID_PATTERN_ANGLE,            22.5 ],
					[ LID_PATTERN_ROW_OFFSET,       10 ],
					[ LID_PATTERN_COL_OFFSET,       130 ],
					[ LID_PATTERN_THICKNESS,        .6	 ],
                ]
            ],
            [ BOX_COMPONENT,									//Auction Tiles and 4) Expansion Leader Cards
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 62, 104, 16] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [ 1,1] ],
					[ POSITION_XY,               [ 5,1 ]],
					[ CMP_SHAPE, SQUARE ],
                    [ CMP_CUTOUT_SIDES_4B, [ t, f, f, f] ],
                    [ CMP_CUTOUT_TYPE, EXTERIOR ],
					[ CMP_CUTOUT_HEIGHT_PCT, 100 ],
                    [ CMP_CUTOUT_WIDTH_PCT, 40],
                ]
            ],
            [ BOX_COMPONENT,									//Family Tiles, 2 stacks of 6
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 57, 66.5, 13] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [ 2, 1] ],
					[ POSITION_XY,               [ 68, 1 ]],
					[ CMP_SHAPE, SQUARE ],
                    [ CMP_CUTOUT_SIDES_4B, [ t, f, f, f] ],
                    [ CMP_CUTOUT_TYPE, EXTERIOR ],
					[ CMP_CUTOUT_HEIGHT_PCT, 100 ],
                    [ CMP_CUTOUT_WIDTH_PCT, 40],
                ]
            ],
            [ BOX_COMPONENT,									//NOT USED 4) Expansion Leader Cards
                [
					[ ENABLED_B, f ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 93, 62, 16] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [ 1,1] ],
					[ POSITION_XY,               [ 1,68.5 ]],
					[ CMP_SHAPE, SQUARE ],
                ]
            ],
            [ BOX_COMPONENT,									//3 Faith Tiles, 2 Excomm tiles, 2 Dev cards
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 89, 46, 14] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [1,1] ],
					[ POSITION_XY,               [ 68, 68.5 ]],
					[ CMP_SHAPE, SQUARE ],
                ]
            ],
            [ BOX_COMPONENT,									//Brown Pawn
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 25, 35, 16] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [ 1, 1] ],
					[ POSITION_XY,               [ 158, 68.5 ]],
					[ CMP_SHAPE, FILLET ],
					[ CMP_FILLET_RADIUS, 7.5 ],
					[ CMP_SHAPE_ROTATED_B, t],
                ]
            ],
            [ BOX_COMPONENT,									//7 stacks tokens: 6 Special, 1 Visconti
                [
					[ ENABLED_B, f ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 21, 21, 12 ] ],
                    [ CMP_NUM_COMPARTMENTS_XY,   [ 7, 1] ],
					[ POSITION_XY,               [ CENTER, 117.5 ]],
					[ CMP_SHAPE, ROUND ],
					[ CMP_SHAPE_VERTICAL_B, t ],
                    [ CMP_CUTOUT_SIDES_4B, [ f, t, f, f] ],
                    [ CMP_CUTOUT_TYPE, EXTERIOR ],
					[ CMP_CUTOUT_HEIGHT_PCT, 100 ],
                    [ CMP_CUTOUT_WIDTH_PCT, 66],
					[ CMP_CUTOUT_DEPTH_PCT, 25 ],
                ]
            ],
        ]
    ],

    [   "Special Development Cards and Special Tower Tile",
        [
            [ ENABLED_B, f ],
            [ BOX_SIZE_XYZ,                                     [172, 90, 13] ],
            [ BOX_STACKABLE_B, f ],
            [ BOX_LID,
                [
                    [ LID_SOLID_B, f],
                    [ LID_FIT_UNDER_B, t],
					[ LID_PATTERN_RADIUS,         5],        
					[ LID_PATTERN_N1,               8 ],
					[ LID_PATTERN_N2,               8 ],
					[ LID_PATTERN_ANGLE,            22.5 ],
					[ LID_PATTERN_ROW_OFFSET,       10 ],
					[ LID_PATTERN_COL_OFFSET,       130 ],
					[ LID_PATTERN_THICKNESS,        .6	 ],
                ]
            ],
            [ BOX_COMPONENT,									//Special Development Cards
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 46, 70, 12 ] ],
                    [ CMP_NUM_COMPARTMENTS_XY,               [3,1] ],
					[ POSITION_XY, [ CENTER, 1] ],
                    [ CMP_CUTOUT_SIDES_4B, [ t, f, f, f] ],
                    [ CMP_CUTOUT_TYPE, EXTERIOR ],
					[ CMP_CUTOUT_HEIGHT_PCT, 100],
                    [ CMP_CUTOUT_WIDTH_PCT, 35],
					[ CMP_CUTOUT_BOTTOM_B, f ],
                ]
            ],
            [ BOX_COMPONENT,									//Special Tower Tile
                [
					[ ENABLED_B, t ],
                    [ CMP_COMPARTMENT_SIZE_XYZ,  [ 168, 86, 6 ] ],
                    [ CMP_NUM_COMPARTMENTS_XY,               [1,1] ],
					[ POSITION_XY, [ CENTER, CENTER] ],
                    [ CMP_CUTOUT_SIDES_4B, [ t, t, f, f] ],
                    [ CMP_CUTOUT_TYPE, EXTERIOR ],
					[ CMP_CUTOUT_HEIGHT_PCT, 15],
                    [ CMP_CUTOUT_WIDTH_PCT, 8],
					[ CMP_CUTOUT_BOTTOM_B, f ],
                ]
            ],
        ]
    ],
];

MakeAll();

