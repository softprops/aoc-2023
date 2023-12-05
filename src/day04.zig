const std = @import("std");

fn part1(input: []const u8) !i32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    var lines = std.mem.split(u8, input, "\n");
    var sum: i32 = 0;
    while (lines.next()) |line| {
        var parts = std.mem.split(u8, line, ": ");
        _ = parts.next();
        const numbers = parts.next().?;
        var number_split = std.mem.split(u8, numbers, " | ");

        var winning_numbers = blk: {
            var split = std.mem.split(u8, number_split.next().?, " ");
            var result = std.StringHashMap(void).init(allocator);
            while (split.next()) |num| {
                if (!std.mem.eql(u8, num, "")) {
                    try result.put(num, {});
                }
            }
            break :blk result;
        };
        defer winning_numbers.deinit();

        var given_numbers = blk: {
            var split = std.mem.split(u8, number_split.next().?, " ");
            var result = std.ArrayList([]const u8).init(allocator);
            while (split.next()) |num| {
                if (!std.mem.eql(u8, num, "")) {
                    try result.append(num);
                }
            }
            break :blk result;
        };
        defer given_numbers.deinit();
        var matching: i32 = 0;
        var given = try given_numbers.toOwnedSlice();
        defer allocator.free(given);
        for (given) |n| {
            if (winning_numbers.contains(n)) {
                matching += 1;
            }
        }
        switch (matching) {
            0 => {},
            1 => {
                sum += 1;
            },
            else => {
                sum += std.math.pow(i32, 2, matching - 1);
            },
        }
    }

    return sum;
}

test "example one" {
    try std.testing.expectEqual(part1(
        \\Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        \\Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        \\Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        \\Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        \\Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        \\Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    ), 13);
}

test "input one" {
    try std.testing.expectEqual(part1(@embedFile("day04.txt")), 27_059);
}
