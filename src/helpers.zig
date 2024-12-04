const std = @import("std");
const build_options = @import("build_options");

pub inline fn inputFile() []const u8 {
    return comptime std.fmt.comptimePrint("inputs/{s}.txt", .{build_options.day});
}
