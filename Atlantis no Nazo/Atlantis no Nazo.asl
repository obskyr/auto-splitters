// == Auto-splitter for Atlantis no Nazo, version 1.0 ==
// Written by @obskyr on 2023-02-01 while listening to https://youtu.be/Y6ZMtAHMb6.
// Thanks to @zharkula for the RAM offsets for the various emulators.
//
// Supports the following emulators:
// • Mesen 0.9.9
// • Mesen 0.9.8
// • FCEUX 2.2.3
// • Nestopia 1.40
//
// Supports the following categories:
// • Any%
// • Hidden Final Zone
// • Any% Star
// • All Zones (partially – no enforceable route)
// • Any% Unrestricted (partially – no enforceable route)

// == Values used ==

// Note: I haven't done exhaustive testing on what these states truly
// represent – some of them may be what music is playing, etc.
// Thus, this auto-splitter may or may not yield buggy behavior when playing
// the game casually, as opposed to following a route.

// State 1 offset: 0x013F.
// State 1 = 0x80: Title screen.
// State 1 = 0x81: Playing or at the very first zone start screen.
// State 1 = 0x82: Zone start screen.

// State 2 offset: 0x01F7.
// State 2 = 0x37: "CONGRATULATION" text displayed.

// Attract mode timer offset: 0x0141.
// Part of a two-byte counter. When this is 0, you're in attract mode.

// "Hidden zone bonus collected" offset: 0x01A0.
// This value switches from 0x00 to 0xFF the frame you receive 4,000,000 points
// from the freaky face in the hidden final zone. (It strikes me as odd that
// there'd be a full one-byte flag for just this, so this may yield false
// positives. If that turns out to be the case, hit me up.)

// Zone offset: 0x0192;
// Zone 1 is 0x00; zone 2 is 0x01; and so on.

// "Diamond collected" offset: 0x0190.
// This value switches from 0x00 to 0xFF the moment you collect the diamond,
// but that happens a few frames before the "CONGRATULATION" text is displayed,
// which is when time is according to the rules.

state("mesen", "0.9.9.0")
{
	byte state_1:            "MesenCore.dll", 0x042E0F30, 0, 0x58, 0xC90, 0x58, 0x013F;
    byte state_2:            "MesenCore.dll", 0x042E0F30, 0, 0x58, 0xC90, 0x58, 0x01F7;
    byte attract_mode_timer: "MesenCore.dll", 0x042E0F30, 0, 0x58, 0xC90, 0x58, 0x0141;
    byte hidden_zone_bonus:  "MesenCore.dll", 0x042E0F30, 0, 0x58, 0xC90, 0x58, 0x01A0;
	byte zone:               "MesenCore.dll", 0x042E0F30, 0, 0x58, 0xC90, 0x58, 0x0192;
}

state("mesen", "0.9.8.0")
{
	byte state_1:            "MesenCore.dll", 0x4327750, 0xB8, 0x78, 0x013F;
    byte state_2:            "MesenCore.dll", 0x4327750, 0xB8, 0x78, 0x01F7;
    byte attract_mode_timer: "MesenCore.dll", 0x4327750, 0xB8, 0x78, 0x0141;
    byte hidden_zone_bonus:  "MesenCore.dll", 0x4327750, 0xB8, 0x78, 0x01A0;
	byte zone:               "MesenCore.dll", 0x4327750, 0xB8, 0x78, 0x0192;
}


state("fceux", "2.2.3")
{
	byte state_1:            0x3B1388, 0x013F;
    byte state_2:            0x3B1388, 0x01F7;
    byte attract_mode_timer: 0x3B1388, 0x0141;
    byte hidden_zone_bonus:  0x3B1388, 0x01A0;
	byte zone:               0x3B1388, 0x0192;
}

state("nestopia", "1.40")
{
	byte state_1:            "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0x013F;
    byte state_2:            "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0x01F7;
    byte attract_mode_timer: "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0x0141;
    byte hidden_zone_bonus:  "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0x01A0;
	byte zone:               "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0x0192;
}

startup
{
    vars.CATEGORY_TO_ROUTE = new Dictionary<string, int[]> {};
    vars.CATEGORY_TO_SPLIT_ON_ZONE_TRANSITION = new Dictionary<string, bool> {};
    vars.CATEGORY_TO_SPLIT_ON_CONGRATULATION = new Dictionary<string, bool> {};
    vars.CATEGORY_TO_SPLIT_ON_HIDDEN_BONUS = new Dictionary<string, bool> {};

    {
        // == Categories ==
        // If the categories are ever changed or added to, this is the
        // section that'll have to be edited.
        // The zone lists are used by the "Enforce route" setting.
        // Note: The final zone and the hidden final zone share #100.

        // Normally I wouldn't write code this muppety, but… LiveSplit's
        // script format allows absolutely nothing outside of the pre-defined
        // functions. That means no functions, and no constants. :|
        
        // === Category: Any% ===
        vars.CATEGORY_TO_ROUTE["Any%"] = new int[] {1, 11, 52, 91, 95, 93, 96, 98, 99, 100};
        vars.CATEGORY_TO_SPLIT_ON_ZONE_TRANSITION["Any%"] = true;
        vars.CATEGORY_TO_SPLIT_ON_CONGRATULATION["Any%"] = true;
        vars.CATEGORY_TO_SPLIT_ON_HIDDEN_BONUS["Any%"] = false;

        vars.CATEGORY_TO_ROUTE["Any% (No Turbo)"] = vars.CATEGORY_TO_ROUTE["Any%"];
        vars.CATEGORY_TO_SPLIT_ON_ZONE_TRANSITION["Any% (No Turbo)"] = vars.CATEGORY_TO_SPLIT_ON_ZONE_TRANSITION["Any%"];
        vars.CATEGORY_TO_SPLIT_ON_CONGRATULATION["Any% (No Turbo)"] = vars.CATEGORY_TO_SPLIT_ON_CONGRATULATION["Any%"];
        vars.CATEGORY_TO_SPLIT_ON_HIDDEN_BONUS["Any% (No Turbo)"] = vars.CATEGORY_TO_SPLIT_ON_HIDDEN_BONUS["Any%"];

        vars.CATEGORY_TO_ROUTE["Any% (Turbo)"] = vars.CATEGORY_TO_ROUTE["Any%"];
        vars.CATEGORY_TO_SPLIT_ON_ZONE_TRANSITION["Any% (Turbo)"] = vars.CATEGORY_TO_SPLIT_ON_ZONE_TRANSITION["Any%"];
        vars.CATEGORY_TO_SPLIT_ON_CONGRATULATION["Any% (Turbo)"] = vars.CATEGORY_TO_SPLIT_ON_CONGRATULATION["Any%"];
        vars.CATEGORY_TO_SPLIT_ON_HIDDEN_BONUS["Any% (Turbo)"] = vars.CATEGORY_TO_SPLIT_ON_HIDDEN_BONUS["Any%"];

        // === Category: Hidden Final Zone ===
        vars.CATEGORY_TO_ROUTE["Hidden Final Zone"] = new int[] {1, 2, 3, 6, 8, 20, 100};
        vars.CATEGORY_TO_SPLIT_ON_ZONE_TRANSITION["Hidden Final Zone"] = true;
        vars.CATEGORY_TO_SPLIT_ON_CONGRATULATION["Hidden Final Zone"] = false;
        vars.CATEGORY_TO_SPLIT_ON_HIDDEN_BONUS["Hidden Final Zone"] = true;

        // === Category: Any% Star ===
        vars.CATEGORY_TO_ROUTE["Any% Star"] = new int[] {1, 2, 3, 6, 8, 10, 4, 25, 41, 94, 97, 100};
        vars.CATEGORY_TO_SPLIT_ON_ZONE_TRANSITION["Any% Star"] = true;
        vars.CATEGORY_TO_SPLIT_ON_CONGRATULATION["Any% Star"] = true;
        vars.CATEGORY_TO_SPLIT_ON_HIDDEN_BONUS["Any% Star"] = false;

        // === Category: All Zones ===
        vars.CATEGORY_TO_ROUTE["All Zones"] = new int[0]; // No commonly used route yet.
        vars.CATEGORY_TO_SPLIT_ON_ZONE_TRANSITION["All Zones"] = true;
        vars.CATEGORY_TO_SPLIT_ON_CONGRATULATION["All Zones"] = true;
        vars.CATEGORY_TO_SPLIT_ON_HIDDEN_BONUS["All Zones"] = false;

        // === Category: Any% Unrestricted ===
        vars.CATEGORY_TO_ROUTE["Any% Unrestricted"] = new int[0]; // No commonly used segments yet.
        vars.CATEGORY_TO_SPLIT_ON_ZONE_TRANSITION["Any% Unrestricted"] = false;
        vars.CATEGORY_TO_SPLIT_ON_CONGRATULATION["Any% Unrestricted"] = true;
        vars.CATEGORY_TO_SPLIT_ON_HIDDEN_BONUS["Any% Unrestricted"] = false;
    }
    
    var routes_s = "";
    foreach (var entry in vars.CATEGORY_TO_ROUTE) {
        if (entry.Value.Length == 0) {continue;}
        routes_s += "\n• " + entry.Key + ": " + string.Join("→", entry.Value);
    }

    settings.Add("enforce_route", false, "Split only on the category's specific route");
    settings.SetToolTip("enforce_route",
        "With this turned off, splits will happen on every zone transition\n" +
        "(except for in the category Any% Unrestricted, which doesn't split\n" +
        "on zones). With it turned on, splits will only happen on a transition\n" +
        "that's included in the route for the category.\n" +
        "The built-in routes are as following:" + routes_s);
}

init
{
	version = modules.First().FileVersionInfo.FileVersion;
}

start
{

	if (old.state_1 == 0x80 && current.state_1 == 0x81 && current.attract_mode_timer != 0x00) {return true;}
}

onStart {
    var category = timer.Run.GetExtendedCategoryName();
    if (vars.CATEGORY_TO_ROUTE.ContainsKey(category)) {
        vars.ROUTE = vars.CATEGORY_TO_ROUTE[category];
    } else {
        vars.ROUTE = new int[0];
    }
    vars.ENFORCE_ROUTE = settings["enforce_route"] && vars.ROUTE.Length > 0;

    // Sure wish C# had something akin to Python's dict.get() method.
    if (vars.CATEGORY_TO_SPLIT_ON_ZONE_TRANSITION.ContainsKey(category)) {
        vars.SPLIT_ON_ZONE_TRANSITION = vars.CATEGORY_TO_SPLIT_ON_ZONE_TRANSITION[category];
    } else {vars.SPLIT_ON_ZONE_TRANSITION = true;}

    if (vars.CATEGORY_TO_SPLIT_ON_CONGRATULATION.ContainsKey(category)) {
        vars.SPLIT_ON_CONGRATULATION = vars.CATEGORY_TO_SPLIT_ON_CONGRATULATION[category];
    } else {vars.SPLIT_ON_CONGRATULATION = true;}

    if (vars.CATEGORY_TO_SPLIT_ON_HIDDEN_BONUS.ContainsKey(category)) {
        vars.SPLIT_ON_HIDDEN_BONUS = vars.CATEGORY_TO_SPLIT_ON_HIDDEN_BONUS[category];
    } else {vars.SPLIT_ON_HIDDEN_BONUS = true;}

    // Because in RAM, the zone numbers are 0-indexed.
    for (var i = 0; i < vars.ROUTE.Length; i++) {
        vars.ROUTE[i] -= 1;
    }
}

split
{
    if (vars.SPLIT_ON_ZONE_TRANSITION && current.zone != old.zone) {
        if (vars.ENFORCE_ROUTE) {
            // Follow enforced route if one exists.
            // Possible improvement that I don't think matters in this game:
            // One could track which transitions have already been done,
            // so that the same transition wouldn't trigger a split twice
            // (if the runner went back a level for some reason).
            var old_zone_index = Array.IndexOf(vars.ROUTE, old.zone);
            if (old_zone_index != -1 && old_zone_index != vars.ROUTE.Length - 1 &&
                vars.ROUTE[old_zone_index + 1] == current.zone) {
                return true;
            }
        } else {
            // Otherwise, split on any zone transition.
            return true;
        }
    }

    // End-of-game "CONGRATULATION" message.
    if (vars.SPLIT_ON_CONGRATULATION && old.state_2 != 0x37 && current.state_2 == 0x37) {return true;}

    // The 4,000,000 points in the hidden final zone.
    if (vars.SPLIT_ON_HIDDEN_BONUS && old.hidden_zone_bonus != 0xFF && current.hidden_zone_bonus == 0xFF) {return true;}
}

reset
{
	return old.state_1 != 0x80 && current.state_1 == 0x80;
}
