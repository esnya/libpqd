module libpqd.param;

import libpqd.pq;
import libpqd.type;
import std.bitmanip;
import std.traits;

/// Parameter of query
struct Param {
    ubyte[] value;
    Type type;
    int format;
    
    this(T)(T value, Type type) if (!isArray!T) in {
        assert(type.len > 0 && T.sizeof == type.len);
    } body {
        this.type = type;
        this.value = nativeToBigEndian(value).dup;
    }
    
    this(T)(T value, Type type) if (isArray!T) in {
        assert(type.len == -1);
    } body {
        this.type = type;
        this.value = cast(ubyte[])cast(void[])value;
    }
    
    this(T)(T value) if (is(typeof(PGTypeOf!T))) {
        this(value, PGTypeOf!T);
    }
    
    @property int length() const {
        return cast(int)value.length;
    }
}