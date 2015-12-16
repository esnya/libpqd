module libpqd.connection;

import libpqd.param;
import libpqd.pq;
import libpqd.result;
import std.string;
import std.traits;

class Connection {
    enum ParameterKeyword {
        host,
        hostaddr,
        port,
        dbname,
        user,
        password,
        connect_timeout,
        client_encoding,
        options,
        application_name,
        fallback_application_name,
        keepalives,
        keepalives_idle,
        keepalives_interval,
        keepalives_count,
        tty,
        sslmode,
        requiressl,
        sslcert,
        sslkey,
        sslrootcert,
        sslcrl,
        requirepeer,
        krbsrvname,
        gsslib,
        service,
    }
    
    enum SSLMode {
        disabled,
        allow,
        prefer,
        require,
        verify_ca,
        verify_full,
    }
    
    /// Create connection from existing connection
    this(PGconn* conn) in {
        assert(conn);
    } body {
        _conn = conn;
    }
    
    /// Connect with ParameterKewyord and parameters
    this(T...)(T params, bool expand_dbname) if (T.length % 2 == 0) {
        import std.conv;
    
        immutable(char)*[] keywords;
        immutable(char)*[] values;
        
        foreach (i, arg; params) {
            static if (i % 2 == 0) {
                keywords ~= arg.to!string().toStringz();
            } else {
                values ~= arg.to!string().toStringz();
            }
        }
        keywords ~= null;
        values ~= null;
        
        this(PQconnectdbParams(cast(char**)keywords.ptr, cast(char**)values.ptr, expand_dbname));
    }
    ///
    unittest {
        with (Connection.ParameterKeyword) {
            auto conn = new Connection(dbname, "postgres", user, "postgres", true);
        }
    }
    
    /// Connect with connection information string
    this(S)(in S conninfo) if (isSomeString!S) {
        this(PQconnectdb(conninfo.toStringz()));
    }
    ///
    unittest {
        auto conn = new Connection("user=postgres");
    }
    
    private PGconn* _conn;
    /// Get native connection handle
    @property PGconn* conn() {
        return _conn;
    }
    
    auto enforce(T)(T value, string file = __FILE__, size_t line = __LINE__) {
        import std.exception;
        return enforce(value, PQerrorMessage(_conn).fromStringz(), file, line);
    }
    
    private template PQConnectionStatus(string param) {
        mixin("alias PQConnectionStatus = PQ" ~ param ~ ';');
    }
    
    /// Connection satatus
    @property auto opDispatch(string op)() const if (is(typeof(PQConnectionStatus!op))) {
        auto result = PQConnectionStatus!op(cast(PGconn*)_conn);
        static if (is(typeof(result) == char*)) {
            return result.fromStringz();
        } else {
            return result;
        }
    }
    /// ditto
    @property auto opDispatch(string op)() const if (!is(typeof(PQConnectionStatus!op))) {
        return PQparameterStatus(cast(PGconn*)_conn, cast(char*)op.toStringz()).fromStringz();
    }
    ///
    unittest {
        auto conn = new Connection("user=postgres");
        assert(conn.server_version);
        assert(conn.status == ConnStatusType.CONNECTION_OK);
        assert(conn.user == "postgres");
        assert(conn.db == "postgres");
    }
    
    /// Execute command
    Result exec(S)(in S command) if (isSomeString!S) {
        return new Result(enforce(PQexec(_conn, command.toStringz())));
    }
    ///
    unittest {
        auto conn = new Connection("user=postgres");
        auto result = conn.exec("SELECT 1234");
        assert(result.status == ExecStatusType.PGRES_TUPLES_OK);
        assert(result.tuples == 1); assert(result.rows == 1);
        assert(result.fields == 1); assert(result.cols == 1);
    }
    /// ditto
    Result exec(S)(in S command, Param[] params, bool binary = false) if (isSomeString!S) in {
        assert(params.length <= int.max);
    } body {
        import std.algorithm;
        import std.range;
        
        Oid[] types = params.map!`a.type.oid`.array;
        ubyte*[] values = params.map!`a.value.ptr`.array;
        int[] lengths = params.map!`a.length`.array;
        int[] formats = params.map!`1`.array;
        
        return new Result(enforce(PQexecParams(_conn, command.toStringz(), cast(int)params.length, types.ptr, cast(const(ubyte)**)values.ptr, lengths.ptr, formats.ptr, binary)));
    }
    ///
    unittest {
        import libpqd.type;
        
        auto conn = new Connection("user=postgres");
        auto result = conn.exec("SELECT $1 || 'bar' AS Text, $2 * 2 AS Integer, NULL AS Null", [Param("foo", Type.PGtext), Param(1234)], true);
        assert(result.status == ExecStatusType.PGRES_TUPLES_OK);
        assert(result.tuples == 1); assert(result.rows == 1);
        assert(result.fields == 3); assert(result.cols == 3);
        assert(result.fields[0].name == "text");
        assert(result.fields[1].name == "integer");
        assert(result.fields[2].name == "null");
        assert(result.fields.numberOf("integer") == 1);
        assert(result.fields.numberOf("NULL") == 2);
        assert(result.fields.numberOf("Text") == 0);
        assert(result.fields[0].format);
        assert(result.fields[1].format);
        assert(result.fields[2].format);
        assert(result.fields[0].type == Type.PGtext.oid);
        assert(result.fields[1].type == Type.PGint4.oid);
        assert(result.fields[2].type == Type.PGunknown.oid);
        assert(result.fields[0].size == Type.PGtext.len);
        assert(result.fields[1].size == Type.PGint4.len);
        assert(result.fields[2].size == Type.PGunknown.len);
        assert(result.binaryTuples);
        
        assert(!result[0, 0].isNull);
        assert(!result[0, 1].isNull);
        assert(result[0, 2].isNull);
        
        assert(result[0, 0].value == [cast(ubyte)'f', 'o', 'o', 'b', 'a', 'r']);
        assert(result[0, 1].value == [0, 0, 0x09, 0xA4]);
        
        assert(result[0, 0].as!string == "foobar");
        assert(result[0, 1].as!int == 2468);
        
        assert(result[0, 0].length == "foobar".length);
        assert(result[0, 1].length == int.sizeof);
    }
}