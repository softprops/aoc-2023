const std = @import("std");

fn solve(input: []const u8) !i32 {
    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        std.debug.print("line {s}\n", .{line});
    }
    return 0;
}

test "day1" {
    try std.testing.expectEqual(solve(@embedFile("day01.txt")), 0);
}
