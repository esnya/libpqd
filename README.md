# libpqd
Small wrapper of libpq (derelict-pq) for D.

## Example
```d
import libpqd;

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
```
