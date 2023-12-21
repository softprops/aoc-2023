const std = @import("std");

// possible cards in lowest to higheset rank so that std.mem.indexOf(..) returns a low to high value
const CARDS: []const u8 = "23456789TJQKA";

const HandType = enum {
    high_card, // all distinct
    one_pair, // on pair and rest distinct
    two_pair, // two pairs and rest distinct
    three_of_a_kind, // three cards the same and rest distict
    full_house, // three cards the same and one pair
    four_of_a_kind, // four cards the same
    five_of_a_kind, // five cards the same

    fn rank(self: HandType) u8 {
        return @intFromEnum(self);
    }

    fn from(allocator: std.mem.Allocator, cards: []const u8) !HandType {
        var counter = std.AutoHashMap(u8, usize).init(allocator);
        defer counter.deinit();
        for (cards) |c| {
            try counter.put(c, (counter.get(c) orelse 0) + 1);
        }
        var it = counter.iterator();
        var pairs: usize = 0;
        var threes: usize = 0;
        while (it.next()) |entry| {
            switch (entry.value_ptr.*) {
                5 => {
                    return .five_of_a_kind;
                },
                4 => {
                    return .four_of_a_kind;
                },
                3 => {
                    threes += 1;
                },
                2 => {
                    pairs += 1;
                },
                else => {},
            }
        }
        if (threes > 0) {
            return if (pairs > 0) .full_house else .three_of_a_kind;
        }
        if (pairs > 0) {
            return if (pairs > 1) .two_pair else .one_pair;
        }
        return .high_card;
    }
};

const Pair = struct {
    hand: []const u8,
    bid: usize,
    allocator: std.mem.Allocator,

    fn handType(self: Pair) !HandType {
        return HandType.from(self.allocator, self.hand);
    }
};

fn lessThanByHand(context: void, a: Pair, b: Pair) bool {
    _ = context;
    const handTypeA = (a.handType() catch unreachable).rank();
    const handTypeB = (b.handType() catch unreachable).rank();
    if (handTypeA < handTypeB) {
        return true;
    }
    if (handTypeA > handTypeB) {
        return false;
    }

    for (a.hand, b.hand) |cardA, cardB| {
        const indexA = std.mem.indexOfScalar(u8, CARDS, cardA) orelse 0;
        const indexB = std.mem.indexOfScalar(u8, CARDS, cardB) orelse 0;
        if (indexA < indexB) {
            return true;
        }
        if (indexA > indexB) {
            return false;
        }
    }
    return false;
}

fn part1(input: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var list = std.ArrayList(Pair).init(allocator);
    defer list.deinit();
    var lines = std.mem.split(u8, input, "\n");
    var sum: usize = 0;
    // sort based on rank of handle then sub bid * rank
    while (lines.next()) |line| {
        var parts = std.mem.split(u8, line, " ");
        var hand = parts.next().?;
        var bid = try std.fmt.parseInt(usize, parts.next().?, 10);
        try list.append(.{ .hand = hand, .bid = bid, .allocator = allocator });
    }
    var sorted = try list.toOwnedSlice();
    defer allocator.free(sorted);
    std.mem.sort(Pair, sorted, {}, lessThanByHand);
    for (sorted, 1..) |pair, rank| {
        //std.debug.print("rank {d} hand {s}\n", .{ rank, pair.hand });
        sum += (pair.bid * rank);
    }
    return sum;
}

test "example one" {
    try std.testing.expectEqual(part1(
        \\32T3K 765
        \\T55J5 684
        \\KK677 28
        \\KTJJT 220
        \\QQQJA 483
    ), 6_440);
}

test "input one" {
    try std.testing.expectEqual(part1(@embedFile("day07.txt")), 251_136_060);
}
