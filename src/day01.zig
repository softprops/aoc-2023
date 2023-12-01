const std = @import("std");

fn digit(c: u8) u8 {
    return switch (c) {
        '0'...'9' => c - '0',
        else => unreachable,
    };
}

fn part1(input: []const u8) !i32 {
    var lines = std.mem.split(u8, input, "\n");
    var sum: i32 = 0;
    while (lines.next()) |line| {
        std.debug.print("line {s}\n", .{line});
        var first: ?u8 = null;
        var last: ?u8 = null;
        for (line) |c| {
            if (std.ascii.isDigit(c)) {
                if (first) |_| {
                    last = c;
                } else {
                    first = c;
                }
            }
        }
        sum +%= try std.fmt.parseInt(i32, &[_]u8{ first.?, (last orelse first).? }, 10);
    }
    return sum;
}

const NUMBERS = std.ComptimeStringMap(
    u8,
    .{
        .{ "one", '1' },
        .{ "two", '2' },
        .{ "three", '3' },
        .{ "four", '4' },
        .{ "five", '5' },
        .{ "six", '6' },
        .{ "seven", '7' },
        .{ "eight", '8' },
        .{ "nine", '9' },
    },
);

fn part2(input: []const u8) !i32 {
    var lines = std.mem.split(u8, input, "\n");
    var sum: i32 = 0;
    while (lines.next()) |line| {
        std.debug.print("line {s}\n", .{line});
        var first: ?u8 = null;
        var last: ?u8 = null;
        for (line, 0..) |c, i| {
            if (std.ascii.isDigit(c)) {
                if (first) |_| {
                    last = c;
                } else {
                    first = c;
                }
            } else {
                // if (std.mem.indexOfAnyPos(u8, line, i, NUMBERS.keys())) |idx| {
                //     std.debug.print("found possible value at position {d}", .{idx});
                // }
            }
        }
        sum +%= try std.fmt.parseInt(i32, &[_]u8{ first.?, (last orelse first).? }, 10);
    }
    return sum;
}

test "example one" {
    try std.testing.expectEqual(part1(
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ), 142);
}

test "part one" {
    try std.testing.expectEqual(part1(@embedFile("day01.txt")), 54_990);
}

test "example two" {
    try std.testing.expectEqual(part2(
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
    ), 281);
}
