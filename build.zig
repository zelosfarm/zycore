const std = @import("std");
const builtin = @import("builtin");

const ArrayList = std.ArrayList;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zycore = b.addStaticLibrary(.{
        .name = "zycore",
        .target = target,
        .optimize = optimize,
    });
    zycore.linkLibC();
    zycore.addIncludePath(.{ .path = "include" });
    zycore.addIncludePath(.{ .path = "src" });

    var zycore_flags = ArrayList([]const u8).init(b.allocator);
    var zycore_sources = ArrayList([]const u8).init(b.allocator);
    defer zycore_flags.deinit();
    defer zycore_sources.deinit();

    zycore_flags.append("-DZYCORE_STATIC_BUILD=1") catch @panic("OOM");
    zycore_sources.append("src/API/Memory.c") catch @panic("OOM");
    zycore_sources.append("src/API/Process.c") catch @panic("OOM");
    zycore_sources.append("src/API/Synchronization.c") catch @panic("OOM");
    zycore_sources.append("src/API/Terminal.c") catch @panic("OOM");
    zycore_sources.append("src/API/Thread.c") catch @panic("OOM");
    zycore_sources.append("src/Allocator.c") catch @panic("OOM");
    zycore_sources.append("src/ArgParse.c") catch @panic("OOM");
    zycore_sources.append("src/Bitset.c") catch @panic("OOM");
    zycore_sources.append("src/Format.c") catch @panic("OOM");
    zycore_sources.append("src/List.c") catch @panic("OOM");
    zycore_sources.append("src/String.c") catch @panic("OOM");
    zycore_sources.append("src/Vector.c") catch @panic("OOM");
    zycore_sources.append("src/Zycore.c") catch @panic("OOM");
    zycore.addCSourceFiles(.{ .files = zycore_sources.items, .flags = zycore_flags.items });

    zycore.installHeadersDirectory("include/Zycore", "Zycore");

    b.installArtifact(zycore);
}
