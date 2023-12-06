const std = @import("std");

fn part1(input: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    var lines = std.mem.split(u8, input, "\n");
    var product: usize = 1;
    var times = blk: {
        const time_line = lines.next().?;
        var parts = std.mem.split(u8, time_line, ":");
        _ = parts.next().?;

        var split = std.mem.split(u8, parts.next().?, " ");
        var result = std.ArrayList(usize).init(allocator);
        while (split.next()) |num| {
            if (!std.mem.eql(u8, num, "")) {
                try result.append(try std.fmt.parseInt(usize, num, 10));
            }
        }
        break :blk result;
    };
    defer times.deinit();
    var distances = blk: {
        const distance_line = lines.next().?;
        var parts = std.mem.split(u8, distance_line, ":");
        _ = parts.next().?;
        var split = std.mem.split(u8, parts.next().?, " ");
        var result = std.ArrayList(usize).init(allocator);
        while (split.next()) |num| {
            if (!std.mem.eql(u8, num, "")) {
                try result.append(try std.fmt.parseInt(usize, num, 10));
            }
        }
        break :blk result;
    };
    defer distances.deinit();
    const time_slice = try times.toOwnedSlice();
    defer allocator.free(time_slice);
    const dist_slice = try distances.toOwnedSlice();
    defer allocator.free(dist_slice);
    for (time_slice, dist_slice) |time, dist| {
        var ways: usize = 0;
        for (1..time) |option| {
            const traveled = (option * (time - option));
            if (traveled > dist) {
                ways += 1;
            }
        }
        if (ways > 0) {
            product *= ways;
        }
    }
    return product;
}

test "example one" {
    try std.testing.expectEqual(part1(
        \\Time:      7  15   30
        \\Distance:  9  40  200
    ), 288);
}

test "input one" {
    try std.testing.expectEqual(part1(@embedFile("day06.txt")), 800280);
}
