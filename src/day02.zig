const std = @import("std");

const Color = enum { red, blue, green };

const CONFIG = std.ComptimeStringMap(
    i32,
    .{
        .{ "red", 12 },
        .{ "green", 13 },
        .{ "blue", 14 },
    },
);

fn part1(input: []const u8) !i32 {
    var lines = std.mem.split(u8, input, "\n");
    var sum: i32 = 0;
    while (lines.next()) |line| {
        var possible = true;
        var game = std.mem.split(u8, line, ": ");
        var prefix = std.mem.split(u8, game.next().?, " ");
        _ = prefix.next().?;
        const id = try std.fmt.parseInt(i32, prefix.next().?, 10);
        const subsets = game.next().?;
        var set = std.mem.split(u8, subsets, "; ");
        while (set.next()) |s| {
            var cubes = std.mem.split(u8, s, ", ");
            while (cubes.next()) |c| {
                var tally = std.mem.split(u8, c, " ");
                const count = try std.fmt.parseInt(i32, tally.next().?, 10);
                const color = tally.next().?;
                if (count > CONFIG.get(color).?) {
                    possible = false;
                }
            }
        }

        if (possible) {
            sum +%= id;
        }
    }
    return sum;
}

fn part2(input: []const u8) !i32 {
    var lines = std.mem.split(u8, input, "\n");
    var sum: i32 = 0;
    while (lines.next()) |line| {
        var game = std.mem.split(u8, line, ": ");
        _ = game.next().?;
        const subsets = game.next().?;
        var set = std.mem.split(u8, subsets, "; ");
        var red: i32 = 0;
        var blue: i32 = 0;
        var green: i32 = 0;
        while (set.next()) |s| {
            var cubes = std.mem.split(u8, s, ", ");
            while (cubes.next()) |c| {
                var tally = std.mem.split(u8, c, " ");
                const count = try std.fmt.parseInt(i32, tally.next().?, 10);
                const color = std.meta.stringToEnum(Color, tally.next().?) orelse unreachable;
                switch (color) {
                    .red => {
                        red = @max(red, count);
                    },
                    .blue => {
                        blue = @max(blue, count);
                    },
                    .green => {
                        green = @max(green, count);
                    },
                }
            }
        }
        sum +%= (red * blue * green);
    }
    return sum;
}
test "example one" {
    try std.testing.expectEqual(part1(
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ), 8);
}

test "input one" {
    try std.testing.expectEqual(part1(@embedFile("day02.txt")), 2_913);
}

test "example two" {
    try std.testing.expectEqual(part2(
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ), 2_286);
}

test "input two" {
    try std.testing.expectEqual(part2(@embedFile("day02.txt")), 55_593);
}
