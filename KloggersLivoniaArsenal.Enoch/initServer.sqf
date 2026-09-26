// Define the H-Barrier asset list where every object costs 50 credits
private _cObjects = [
    ["Land_HBarrier_1_F", 3, "H-Barriers"],           
    ["Land_HBarrier_3_F", 3, "H-Barriers"],           
    ["Land_HBarrier_5_F", 3, "H-Barriers"],           
    ["Land_HBarrier_Big_F", 3, "H-Barriers"],         
    ["Land_HBarrierWall4_F", 3, "H-Barriers"],        
    ["Land_HBarrierWall6_F", 3, "H-Barriers"],        
    ["Land_HBarrierWall_corner_F", 3, "H-Barriers"],  
    ["Land_HBarrierWall_corridor_F", 3, "H-Barriers"],
    ["Land_HBarrierTower_F", 3, "H-Barriers"],
    ["Land_BagFence_Long_F", 45, "Sandbags (Tan)"],
    ["Land_BagFence_Short_F", 45, "Sandbags (Tan)"],
    ["Land_BagFence_Round_F", 45, "Sandbags (Tan)"],
    ["Land_BagFence_Corner_F", 45, "Sandbags (Tan)"],
    ["Land_BagFence_End_F", 45, "Sandbags (Tan)"],
    ["Land_BagFence_01_Long_green_F", 45, "Sandbags (Green)"],
    ["Land_BagFence_01_Short_green_F", 45, "Sandbags (Green)"],
    ["Land_BagFence_01_Round_green_F", 45, "Sandbags (Green)"],
    ["Land_BagFence_01_Corner_green_F", 45, "Sandbags (Green)"],
    ["Land_BagFence_01_End_green_F", 45, "Sandbags (Green)"],
    ["CUP_B_AGS_CDF", 30, "Emplacements"],
    ["B_HMG_01_high_F", 30, "Emplacements"],
    ["B_G_HMG_02_high_F", 30, "Emplacements"],
    ["B_Mortar_01_F", 30, "Emplacements"],
    ["CUP_B_TOW_TriPod_US", 30, "Emplacements"]
];

// Register the objects for all sides with an infinite budget (-1)
[west, -1, _cObjects] call acex_fortify_fnc_registerObjects;
[east, -1, _cObjects] call acex_fortify_fnc_registerObjects;
[independent, -1, _cObjects] call acex_fortify_fnc_registerObjects;
[civilian, -1, _cObjects] call acex_fortify_fnc_registerObjects;