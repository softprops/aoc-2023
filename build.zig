const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    // touch src/day{01..25}.zig
    inline for (1..26) |i| {
        var day = b.fmt("day{:0>2}", .{i});
        const tests = b.addTest(.{
            .root_source_file = .{ .path = b.fmt("src/{s}.zig", .{day}) },
            .target = target,
            .optimize = optimize,
        });

        const run_tests = b.addRunArtifact(tests);

        const test_step = b.step(
            b.fmt("test-{s}", .{day}),
            b.fmt("run {s} tests", .{day}),
        );
        test_step.dependOn(&run_tests.step);
    }
}
