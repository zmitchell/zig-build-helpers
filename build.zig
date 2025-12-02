const std = @import("std");
const Build = std.Build;
const Step = Build.Step;
const Module = Build.Module;
const ResolvedTarget = Build.ResolvedTarget;
const OptimizeMode = std.builtin.OptimizeMode;

pub fn build(_: *Build) void {}

/// Adds a step called "run" that runs the provided executable.
pub fn addRunStep(b: *Build, exe: *Step.Compile) void {
    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
}

/// Adds a step called "check" that compiles without producing and installing
/// the final executable. This can be used by zls to provide more feedback
/// during interactive editing.
pub fn addCheckStep(b: *Build, name: []const u8, description: []const u8, exe_mod: *Module) void {
    const check_exe = b.addExecutable(.{
        .name = name,
        .root_module = exe_mod,
    });
    // Skip the installation step
    var check_step = b.step("check", description);
    check_step.dependOn(&check_exe.step);
}

// Pass modules and files as:
// - &[_]*Module { ... }
// - &[_][]const u8 { "foo", "bar", ... }
pub fn addTestStep(b: *Build, target: ResolvedTarget, optimize: OptimizeMode, modules: []const *Module, files: []const []const u8) void {
    const test_step = b.step("test", "Run all tests");
    const test_filters = b.option([]const []const u8, "test-filter", "Skip all tests that don't match a filter") orelse &[0][]const u8{};

    for (modules) |mod| {
        const artifact = b.addTest(.{
            .root_module = mod,
            .filters = test_filters,
        });
        const run = b.addRunArtifact(artifact);
        test_step.dependOn(&run.step);
    }

    for (files) |src_file| {
        const artifact = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(src_file),
                .target = target,
                .optimize = optimize,
            }),
            .filters = test_filters,
        });
        const run = b.addRunArtifact(artifact);
        test_step.dependOn(&run.step);
    }
}
