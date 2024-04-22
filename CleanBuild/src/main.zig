const std = @import("std");
const Dir = std.fs.Dir;
const File = std.fs.File;

// - Take an directory as an argument
// - Shallow walk the dir and match any subdir with an array of dirs that should be deleted
// - Delete those dirs
//
// if args.len != 1 {fail}
// if ! fs.dir.is_path(args[0]) {fail}
// else
// loop subdirs, single level
// if list_of_files_to_delete contains subdir, delete
//

pub fn main() !void {
    const dirs_to_delete = [_][]const u8{
        ".vs",
        "Binaries",
        "DerivedDataCache",
        "Intermediate",
    };

    // Get allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    // Parse args into string array (error union needs 'try')
    // args[0] contains path\to\executable
    // args[1] would be first passed argument
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len != 2) {
        std.debug.print("Program expected to be run with 1 argument given, got {d}\n", .{args.len - 1});
        std.process.exit(1);
    }

    std.debug.print("Args[0] = [{s}]\n", .{args[0]});
    std.debug.print("Args.len = [{d}]\n", .{args.len});

    const opts = Dir.OpenDirOptions{ .iterate = true };

    const args_path = args[1];
    std.debug.print("args_path = [{s}]\n", .{args_path});

    // var working_dir = try std.fs.cwd().openDir(args_path, opts);
    var working_dir = std.fs.cwd().openDir(args_path, opts) catch |e| {
        std.debug.print(
            \\error opening directory: {s}
            \\hint: {s}
        , .{
            @errorName(e),
            switch (e) {
                error.FileNotFound => "Directory not found\n",
                else => "\n",
            },
        });
        std.process.exit(1);
    };

    defer working_dir.close();

    std.debug.print("working_dir = [{}]\n", .{(working_dir)});
    std.debug.print("TypeOf working_dir = [{}]\n", .{@TypeOf(working_dir)});

    var iter = working_dir.iterate();
    while (try iter.next()) |entry| {
        if (entry.kind != File.Kind.directory) {
            continue;
        }

        std.debug.print("File {s} {} ({})\n", .{ entry.name, @TypeOf(entry.name), entry.kind });

        for (dirs_to_delete) |dir_to_delete| {
            // std.debug.print("Dir: {s}; TypeOf ({})\n", .{ dir_to_delete, @TypeOf(dir_to_delete) });

            if (std.mem.eql(u8, dir_to_delete, entry.name)) {
                std.debug.print("Deleting directory [{s}]\n", .{entry.name});
                try Dir.deleteTree(working_dir, entry.name);
            }
        }
    }
}
