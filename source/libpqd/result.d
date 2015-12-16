module libpqd.result;

import libpqd.pq;
import libpqd.type;
import std.string;
import std.traits;

/// Result of query
class Result {
    /// Create from result
    this(PGresult* result) in {
        assert(result);
    } body {
        _result = result;
    }
    
    ~this() {
        PQclear(_result);
    }
    
    T enforce(T)(T value, string file = __FILE__, size_t line = __LINE__) {
        import std.exception;
        
        return enforce(value, PQresultErrorMessage(_result).fromStringz(), file, line);
    }
    
    private PGresult* _result;
    /// Get native handle
    @property PGresult* result() {
        return _result;
    }
    
    /// Get status
    @property ExecStatusType status() const {
        return PQresultStatus(_result);
    }
    
    private template PQResultNumberInformation(string param) {
        mixin("alias PQResultNumberInformation = PQn" ~ param ~ ';');
    }
    int opDispatch(string op)() const if (is(typeof(PQResultNumberInformation!op))) {
        return PQResultNumberInformation!op(cast(PGresult*)_result);
    }
    
    alias rows = opDispatch!"tuples";
    alias columns = opDispatch!"fields";
    alias cols = opDispatch!"fields";
    
    struct Fields {
        private Result _result;
        
        @property size_t length() const {
            return cast(int)PQnfields(cast(PGresult*)_result._result);
        }
        alias length this;
        
        auto opIndex(size_t i) in {
            assert(i < length);
        } body {
            return Field(_result, cast(int)i);
        }
        
        auto numberOf(in char[] name) const {
            return PQfnumber(cast(PGresult*)_result._result, name.toStringz());
        }
    }
    struct Field {
        private Result _result;
        private int _col;
        
        @property auto name() const {
            return PQfname(cast(PGresult*)_result._result, _col).fromStringz();
        }
        
        @property auto table() const {
            return PQftable(cast(PGresult*)_result._result, _col);
        }
        
        @property auto tablecol() const {
            return PQftablecol(cast(PGresult*)_result._result, _col);
        }
        
        @property auto format() const {
            return PQfformat(cast(PGresult*)_result._result, _col);
        }
        
        @property auto type() const {
            return PQftype(cast(PGresult*)_result._result, _col);
        }
        
        @property auto mod() const {
            return PQfmod(cast(PGresult*)_result._result, _col);
        }
        
        @property auto size() const {
            return PQfsize(cast(PGresult*)_result._result, _col);
        }
    }
    
    /// Get fields
    @property Fields fields() {
        return Fields(this);
    }
    
    /// Contains binary data
    @property bool binaryTuples() const {
        return cast(bool)PQbinaryTuples(cast(PGresult*)_result);
    }
    
    struct Value {
        private const PGresult* _result;
        private int _row, _col;
        
        /// Get value
        @property auto value() const {
            return PQgetvalue(cast(PGresult*)_result, _row, _col)[0 .. length];
        }
        
        /// Get length
        @property size_t length() const {
            return cast(size_t)PQgetlength(cast(PGresult*)_result, _row, _col);
        }
        
        /// Get value as T
        @property T as(T)() const if (is(typeof(PGTypeOf!T)) && !isArray!T) in {
            static assert(PGTypeOf!T.len > 0 && T.sizeof == PGTypeOf!T.len);
            assert(length == T.sizeof);
        } body {
            import std.bitmanip;
            return bigEndianToNative!T(value[0 .. T.sizeof]);
        }
        /// ditto
        @property T as(T)() const if (is(typeof(PGTypeOf!T)) && isArray!T) in {
            static assert(PGTypeOf!T.len == -1);
        } body {
            return cast(T)cast(void[])(value);
        }
    }
    /// Get value
    @property auto opIndex(size_t row, size_t col) const {
        import std.typecons;
        
        if (PQgetisnull(cast(PGresult*)_result, cast(int)row, cast(int)col)) {
            return Nullable!Value.init;
        } else {
            return Nullable!Value(Value(_result, cast(int)row, cast(int)col));
        }
    }
    
    
}