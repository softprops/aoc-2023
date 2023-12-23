//! https://adventofcode.com/2023/day/8
const std = @import("std");

const Elements = struct {
    left: []const u8,
    right: []const u8,
};

const TERMINATOR = "ZZZ";

fn part1(input: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var network = std.StringHashMap(Elements).init(allocator);
    defer network.deinit();
    var lines = std.mem.split(u8, input, "\n");
    // RLRLRLRLRLRRLLR...
    const instructions = lines.next().?;
    _ = lines.next(); // empty line
    var steps: usize = 0;

    while (lines.next()) |line| {
        var parts = std.mem.split(u8, line, " = ");
        var node = parts.next().?;
        var element_parts = std.mem.split(u8, parts.next().?, ", ");
        try network.put(node, .{
            .left = std.mem.trimLeft(u8, element_parts.next().?, "("),
            .right = std.mem.trimRight(u8, element_parts.next().?, ")"),
        });
    }

    var current_node: []const u8 = "AAA";
    // compute step min steps to reach network TERMINATOR
    while (!std.mem.eql(u8, current_node, TERMINATOR)) {
        for (instructions) |instruction| {
            switch (instruction) {
                'R' => {
                    current_node = network.get(current_node).?.right;
                    steps += 1;
                    if (std.mem.eql(u8, current_node, TERMINATOR)) {
                        return steps;
                    }
                },
                'L' => {
                    current_node = network.get(current_node).?.left;
                    steps += 1;
                    if (std.mem.eql(u8, current_node, TERMINATOR)) {
                        return steps;
                    }
                },
                else => unreachable,
            }
        }
    }

    return steps;
}

fn part2(input: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var network = std.StringHashMap(Elements).init(allocator);
    defer network.deinit();
    var lines = std.mem.split(u8, input, "\n");
    // RLRLRLRLRLRRLLR...
    const instructions = lines.next().?;
    _ = lines.next(); // empty line
    var steps: usize = 0;

    while (lines.next()) |line| {
        var parts = std.mem.split(u8, line, " = ");
        var node = parts.next().?;
        var element_parts = std.mem.split(u8, parts.next().?, ", ");
        try network.put(node, .{
            .left = std.mem.trimLeft(u8, element_parts.next().?, "("),
            .right = std.mem.trimRight(u8, element_parts.next().?, ")"),
        });
    }

    var starting_points = std.ArrayList([]const u8).init(allocator);
    defer starting_points.deinit();
    var it = network.iterator();
    while (it.next()) |pair| {
        if (std.mem.endsWith(u8, pair.key_ptr.*, "A")) {
            try starting_points.append(pair.key_ptr.*);
        }
    }
    var current_nodes = try starting_points.toOwnedSlice();
    defer allocator.free(current_nodes);

    var terminated = false;
    // compute step min steps to reach network TERMINATOR
    while (!terminated) {
        for (instructions) |instruction| {
            switch (instruction) {
                'R' => {
                    for (current_nodes, 0..) |current_node, i| {
                        current_nodes[i] = network.get(current_node).?.right;
                    }
                    steps += 1;
                    var all_match = true;
                    for (current_nodes) |current_node| {
                        if (!std.mem.endsWith(u8, current_node, "Z")) {
                            all_match = false;
                            break;
                        }
                    }
                    if (all_match) {
                        return steps;
                    }
                },
                'L' => {
                    for (current_nodes, 0..) |current_node, i| {
                        current_nodes[i] = network.get(current_node).?.left;
                    }
                    steps += 1;
                    var all_match = true;
                    for (current_nodes) |current_node| {
                        if (!std.mem.endsWith(u8, current_node, "Z")) {
                            all_match = false;
                            break;
                        }
                    }
                    if (all_match) {
                        return steps;
                    }
                    // return steps;
                },
                else => unreachable,
            }
        }
    }

    return steps;
}

test "example one" {
    try std.testing.expectEqual(part1(
        \\RL
        \\
        \\AAA = (BBB, CCC)
        \\BBB = (DDD, EEE)
        \\CCC = (ZZZ, GGG)
        \\DDD = (DDD, DDD)
        \\EEE = (EEE, EEE)
        \\GGG = (GGG, GGG)
        \\ZZZ = (ZZZ, ZZZ
    ), 2);
}

test "example two" {
    try std.testing.expectEqual(part1(
        \\LLR
        \\
        \\AAA = (BBB, BBB)
        \\BBB = (AAA, ZZZ)
        \\ZZZ = (ZZZ, ZZZ)
    ), 6);
}

test "input one" {
    try std.testing.expectEqual(part1(@embedFile("day08.txt")), 12169);
}

test "example one part two" {
    try std.testing.expectEqual(part2(
        \\LR
        \\
        \\11A = (11B, XXX)
        \\11B = (XXX, 11Z)
        \\11Z = (11B, XXX)
        \\22A = (22B, XXX)
        \\22B = (22C, 22C)
        \\22C = (22Z, 22Z)
        \\22Z = (22B, 22B)
        \\XXX = (XXX, XXX)
    ), 6);
}

test "input two" {
    try std.testing.expectEqual(part2(@embedFile("day08.txt")), 0);
}
