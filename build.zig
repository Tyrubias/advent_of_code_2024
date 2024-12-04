const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    inline for (1..26) |day| {
        const day_str = comptime blk: {
            var buf: [5]u8 = undefined;
            _ = std.fmt.bufPrint(&buf, "day{:0>2}", .{day}) catch unreachable;
            break :blk buf;
        };

        const exe_path = comptime std.fmt.comptimePrint("src/{s}.zig", .{day_str});
        const exe = b.addExecutable(.{
            .name = &day_str,
            .root_source_file = b.path(exe_path),
            .target = target,
            .optimize = optimize,
        });

        const build_step = b.addInstallArtifact(exe, .{});
        const build_step_name = comptime std.fmt.comptimePrint("{s}", .{day_str});
        const build_step_description = comptime std.fmt.comptimePrint("build solution for day {s}", .{day_str});
        b.step(build_step_name, build_step_description).dependOn(&build_step.step);

        const run_cmd = b.addRunArtifact(exe);
        const run_step_name = comptime std.fmt.comptimePrint("run_{s}", .{day_str});
        const run_step_description = comptime std.fmt.comptimePrint("run solution for day {s}", .{day_str});
        b.step(run_step_name, run_step_description).dependOn(&run_cmd.step);

        const test_path = comptime std.fmt.comptimePrint("src/{s}.zig", .{day_str});
        const tests = b.addTest(.{
            .name = &day_str,
            .root_source_file = b.path(test_path),
            .target = target,
            .optimize = optimize,
        });

        const test_step = b.addRunArtifact(tests);
        const test_step_name = comptime std.fmt.comptimePrint("test_{s}", .{day_str});
        const test_step_description = comptime std.fmt.comptimePrint("run tests for day {s}", .{day_str});
        b.step(test_step_name, test_step_description).dependOn(&test_step.step);
    }
}
