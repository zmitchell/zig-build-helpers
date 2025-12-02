const std = @import("std");
const Build = std.Build;
const Step = Build.Step;
const Module = Build.Module;

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
