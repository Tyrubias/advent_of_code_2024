const std = @import("std");
const helpers = @import("helpers.zig");
const input = @embedFile(helpers.inputFile());

pub fn main() !void {
    std.debug.print("{s}", .{input});
}
