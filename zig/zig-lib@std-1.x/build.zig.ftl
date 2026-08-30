const std = @import("std");

pub fn build(b: *std.Build) void {
  const target = b.standardTargetOptions(.{});
  const optimize = b.standardOptimizeOption(.{});

  _ = b.addModule("${app.name}", .{
    .root_source_file = b.path("src/root.zig"),
  });

  // 2. Build the static library (.a on Unix, .lib on Windows)
  const lib = b.addStaticLibrary(.{
    .name = "${app.name}",
    .root_source_file = b.path("src/root.zig"),
    .target = target,
    .optimize = optimize,
  });

  // This tells Zig to write the compiled library to the zig-out/lib directory
  b.installArtifact(lib);

  // 3. Configure the Unit Tests step
  const lib_unit_tests = b.addTest(.{
    .root_source_file = b.path("src/root.zig"),
    .target = target,
    .optimize = optimize,
  });

  const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

  // Expose the "test" step to the terminal (e.g. `zig build test`)
  const test_step = b.step("test", "Run library unit tests");
  test_step.dependOn(&run_lib_unit_tests.step);
}