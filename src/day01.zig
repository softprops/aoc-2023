const std = @import("std");

fn digit(c: u8) u8 {
    return switch (c) {
        '0'...'9' => c - '0',
        else => unreachable,
    };
}

fn solve(input: []const u8) !i32 {
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

test "example one" {
    try std.testing.expectEqual(solve(
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ), 142);
}

test "day1" {
    try std.testing.expectEqual(solve(@embedFile("day01.txt")), 54_990);
}
