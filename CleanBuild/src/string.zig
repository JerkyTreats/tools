const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    // Obvious way to declare a string
    // Non-obvious type this resolves to: `*const [5:0]u8`
    const string_literal = "hello";

    // Let's construct this a different way
    // [] defines array;
    // _ infers the size of array from the number of items added
    // u8 stores each character using 8 bits of memory
    // This is a byte_array that ends up being: `[5]u8`
    const byte_array = [_]u8{
        'h',
        'e',
        'l',
        'l',
        'o',
    };

    // Create a single-item pointer to the byte_array
    // This results in *const [5]u8
    const barr_ptr = &byte_array;

    // Note that "barr_ptr"
    //   *const [5]u8
    // is not the same as "string_literal"
    //   *const [5:0]u8
    // This is because strings are *null terminated* byte arrays.
    // [_:0] defines array, infers size, adds 00000000 (null in 8 bits) at the end
    //
    // The following resolves to `[5:0]u8`
    //
    const null_term_byte_array = [_:0]u8{
        'h',
        'e',
        'l',
        'l',
        'o',
    };

    // Pointer to the null terminated byte array.
    // This gives us *const [5:0]u8
    // And this IS the same as `string_literal`
    const null_barr_ptr = &null_term_byte_array;

    //
    // They all have the same value
    //
    try stdout.print("'string_literal' = {s}\n", .{string_literal});
    try stdout.print("'byte_array' = {s}\n", .{byte_array});
    try stdout.print("'barr_ptr.*' = {s}\n", .{barr_ptr.*});
    try stdout.print("'null_term_byte_array' = {s}\n", .{null_term_byte_array});
    try stdout.print("'null_term_byte_array.*' = {s}\n", .{null_barr_ptr.*});
    // 'string_literal'         = hello
    // 'byte_array'             = hello
    // 'barr_ptr.*'             = hello
    // 'null_term_byte_array'   = hello
    // 'null_term_byte_array.*' = hello

    //
    // But they are not the same thing
    //
    try stdout.print("'string_literal' = {}\n", .{@TypeOf(string_literal)});
    try stdout.print("'byte_array' = {}\n", .{@TypeOf(byte_array)});
    try stdout.print("'barr_ptr' = {}\n", .{@TypeOf(barr_ptr)});
    try stdout.print("'barr_ptr.*' = {}\n", .{@TypeOf(barr_ptr.*)});
    try stdout.print("'null_term_byte_array' = {}\n", .{@TypeOf(null_term_byte_array)});
    try stdout.print("'null_barr_ptr.*' = {}\n", .{@TypeOf(null_barr_ptr.*)});
    // 'string_literal'       = *const [5:0]u8
    // 'byte_array'           = [5]u8
    // 'barr_ptr'             = *const [5]u8
    // 'barr_ptr.*'           = [5]u8
    // 'null_term_byte_array' = [5:0]u8
    // 'null_barr_ptr.*'      = [5:0]u8

    //
    // This is false:
    //
    if (std.meta.eql(&byte_array, string_literal)) {
        try stdout.print("true\n", .{});
    } else {
        try stdout.print("false\n", .{});
    }

    //
    // This is true:
    //
    if (std.meta.eql(&null_term_byte_array, string_literal)) {
        try stdout.print("true\n", .{});
    } else {
        try stdout.print("false\n", .{});
    }
}
