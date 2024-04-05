const std = @import("std");
const Dir = std.fs.Dir;
const File = std.fs.File;

// - Take an directory as an argument
// - Shallow walk the dir and match any subdir with an array of dirs that should be deleted
// - Delete those dirs

pub fn main() !void {
    // const dirs_to_delete = [_][]const u8{
    //     ".vs",
    //     "Binaries",
    //     "DerivedDataCache",
    //     "Intermediate",
    // };

    // Get allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    // Parse args into string array (error union needs 'try')
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    // if args.len != 1 {fail}
    // if ! fs.dir.is_path(args[0]) {fail}
    // else
    // loop subdirs, single level
    // if list_of_files_to_delete contains subdir, delete
    //

    if (args.len != 1) {
        std.debug.print("Expected 1 argument, got {}", .{args.len});
    }

    const opts = Dir.OpenDirOptions{ .iterate = true };

    var working_dir = try std.fs.cwd().openDir(args[0], opts);
    defer working_dir.close();

    var iter = working_dir.iterate();
    while (try iter.next()) |entry| {
        std.debug.print("File {s} ({})\n", .{ entry.name, entry.kind });

        if (entry.kind != File.Kind.directory) {
            continue;
        }

        // for (dirs_to_delete) |dir| {
        //     if (dir == entry.name) {
        //         std.debug.print("Deleting directory [{s}]", .{entry.name});
        //         Dir.deleteTree(working_dir, entry.name);
        //     }
        // }
    }

    // Get and print them!
    std.debug.print("There are {d} args:\n", .{args.len});
    for (args) |arg| {
        std.debug.print("  {s}\n", .{arg});
    }
}
